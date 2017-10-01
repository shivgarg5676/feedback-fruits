class Game < ApplicationRecord
  belongs_to :player1, class_name: "User"
  belongs_to :player2, class_name: "User", optional: true
  has_many :moves, dependent: :destroy
  belongs_to :winner, class_name: 'User', optional: true
  belongs_to :last_move, class_name: 'Move', optional: true
  include Workflow
  workflow do
    state :new do
      event :start_play, :transitions_to => :playing
    end
    state :playing do
      event :game_completed, :transitions_to => :game_completed
    end
    state :game_completed
  end

  def self.played_by(player)
    Game.where(:player1 => player).or(Game.where(:player2 => player))
  end

  def opponent_of(player)
    return self.player1.id == player.id ? self.player2 : self.player1
  end

  def self.end_games_of(player)
    # delete new Games if Any
    new_games_as_player1 = Game.with_new_state.played_by(player).destroy_all
    #update playing Games if Any and set opponent as winner
    playing_games = Game.with_playing_state.played_by(player)
    playing_games.each do |game|
      game.set_winner(game.opponent_of(player))
    end
  end

  def self.join(player)
    game = Game.with_new_state.where(:player1 => player).first
    channel = player.channel_for(Game)
    if game.present?
      ActionCable.server.broadcast channel, message: {type: 'waiting'};
    else
      game_to_play = Game.with_new_state.first
      if game_to_play.present?
        game_to_play.player2 = player
        game_to_play.start_play!
        player1_channel = "game_channel_#{game_to_play.player1.id}"
        ActionCable.server.broadcast player1_channel, message: {type: 'start_play',gameId: game_to_play.id};
        ActionCable.server.broadcast channel, message: {type: 'waiting'};
        game_to_play.save!
      else
        game = Game.create(:player1 => player);
        ActionCable.server.broadcast channel, message: {type: 'waiting'};
      end
    end
  end

  def get_winner
    if self.last_move.is_winning_state_for(self.player1)
      return player1
    elsif self.last_move.is_winning_state_for(self.player2)
      return player2
    else
      return nil
    end
  end
  def set_winner(winner)
    self.winner = winner
    self.game_completed!
  end


  def update_game_state(last_move)
    # check if player is winner
    self.last_move = last_move
    winner = self.get_winner
    self.set_winner(winner) if winner.present?
    #check if a draw
    unless last_move.game_state.include? -1
      set_draw
    end
    self.save!
  end

  def set_draw
    self.game_completed!
  end

  def game_completed
    channel1 = self.player1.channel_for(Game)
    channel2 = self.player2.channel_for(Game)
    ActionCable.server.broadcast channel1, message: {type: 'gameEnd',winner: self.winner.try(:id) };
    ActionCable.server.broadcast channel2, message:{type: 'gameEnd', winner: self.winner.try(:id) };
  end

end
