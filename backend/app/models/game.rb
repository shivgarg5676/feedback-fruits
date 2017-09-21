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


  def self.leave_game(player)
    # delete new Games if Any
    new_games_as_player1 = Game.with_new_state.where(:player1 => player)
    # supposed to be empty
    new_games_as_player2 = Game.with_new_state.where(:player1 => player)
    new_games_as_player1.destroy_all
    new_games_as_player2.destroy_all
    #update playing Games if Any
    playing_games = Game.with_playing_state.where(:player1 => player).or(Game.with_playing_state.where(:player2 => player))
    playing_games.each do |game|
      if game.player1.id == player.id
        game.set_winner(game.player2)
      else
        game.set_winner(game.player1)
      end
    end
  end

  def self.get_new_games(player)
    if(Game.with_new_state.all.length == 0)
      Game.create(:player1 => player)
    end
    Game.with_new_state.all
  end

  def create_move(array,data,player,channel)
    array[data['move'].to_i] = player.id
    move= Move.create(:game_state => array, :player => player, :game => self,:previous_move => self.last_move)
    self.last_move = move
    self.save!
    ActionCable.server.broadcast channel, message: {type: 'start_play',last_move:data['move'].to_i,gameId: self.id };
    set_game_status
  end

  def move(data,player)
    # player moves
    channel = nil
    if player == self.player1
      channel = "game_channel_#{self.player2.id}"
    else
      channel = "game_channel_#{self.player1.id}"
    end
    if self.last_move.present?
      array = self.last_move.game_state
      self.create_move(array, data,player,channel)
    else
      array = Array.new(9, -1)
      self.create_move(array, data,player,channel)
    end
  end

  def self.join(player)
    game = Game.with_new_state.where(:player1 => player).first
    channel =  "game_channel_#{player.id}"
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

  def set_game_status
    winning_conditions= [[0,1,2], [3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    last_move_state = self.last_move.game_state
    # check if player is winner
    winning_conditions.each do |condition|
      if condition.all? {|x| last_move_state[x] == self.player1.id}
        set_winner(player1)
      end
      if condition.all? {|x| last_move_state[x] == self.player2.id}
        set_winner(player2)
      end
    end
    #check if a draw
    unless last_move_state.include? -1
      set_draw
    end
  end
  def set_winner(winner)
    self.winner = winner
    self.save!
    self.game_completed!
  end
  def set_draw
    self.game_completed!
  end
  def game_completed!
    channel1 = "game_channel_#{self.player1.id}"
    channel2 = "game_channel_#{self.player2.id}"
    ActionCable.server.broadcast channel1, message: {type: 'gameEnd',winner: self.winner.try(:id) };
    ActionCable.server.broadcast channel2, message:{type: 'gameEnd', winner: self.winner.try(:id) };
  end

end
