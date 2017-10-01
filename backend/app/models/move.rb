class Move < ApplicationRecord
  serialize :game_state
  belongs_to :player, class_name: 'User'
  belongs_to :game
  belongs_to :previous_move, class_name: 'Move',optional: true

  attr_accessor :move_index

  before_validation :create_game_state
  before_validation :set_previous_move
  after_save :update_game
  after_save :broadcast_messages


  def create_game_state
    self.game_state = self.game.last_move.present? ? self.game.last_move.game_state : Array.new(9, -1)
    self.game_state[move_index] = self.player.id
  end

  def set_previous_move
    self.previous_move = self.game.last_move
  end

  def broadcast_messages
    opponent_channel =  self.game.opponent_of(self.player).channel_for(Game)
    my_channel = self.player.channel_for(Game)
    ActionCable.server.broadcast opponent_channel, message: {type: 'start_play',last_move: self.move_index, gameId: self.game.id };
    ActionCable.server.broadcast my_channel, message: {type: 'pause_play',last_move: self.move_index, gameId: self.game.id };
  end

  def is_winning_state_for(player)
    winning_conditions= [[0,1,2], [3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    winning_conditions.each do |condition|
      if condition.all? {|x| self.game_state[x] == player.id}
        return true
      end
    end
    return false
  end

  def update_game
    self.game.update_game_state(self)
  end


end
