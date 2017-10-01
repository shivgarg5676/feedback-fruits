class Move < ApplicationRecord
  serialize :game_state
  belongs_to :player, class_name: 'User'
  belongs_to :game
  belongs_to :previous_move, class_name: 'Move',optional: true

  attr_accessor :move_index

  before_validation :create_game_state
  before_validation :set_previous_move
  after_save :broadcast_messages
  after_save :set_game_status

  def create_game_state
    self.game_state = self.game.last_move.present? ? self.game.last_move.game_state : Array.new(9, -1)
    self.game_state[move_index] = self.player.id
  end

  def set_previous_move
    self.previous_move = self.game.last_move
  end

  def broadcast_messages
    opponent = self.game.opponent_of(self.player)
    opponent_channel = opponent.channel_for(Game)
    my_channel = self.player.channel_for(Game)
    ActionCable.server.broadcast opponent_channel, message: {type: 'start_play',last_move: self.move_index, gameId: self.game.id };
    ActionCable.server.broadcast my_channel, message: {type: 'pause_play',last_move: self.move_index, gameId: self.game.id };
  end

  def set_game_status
    self.game.set_game_status(self)
  end


end
