class Move < ApplicationRecord
  serialize :state
  belongs_to :player, class_name: 'User'
  belongs_to :game
  belongs_to :previous_move, class_name: 'move'

end
