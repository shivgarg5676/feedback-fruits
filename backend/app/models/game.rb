class Game < ApplicationRecord
  belongs_to :player1, class_name: "User"
  belongs_to :player2, class_name: "User", optional: true
  has_many :moves
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

end
