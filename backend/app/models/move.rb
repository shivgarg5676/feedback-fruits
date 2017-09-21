class Move < ApplicationRecord
  serialize :game_state
  belongs_to :player, class_name: 'User'
  belongs_to :game
  belongs_to :previous_move, class_name: 'Move',optional: true

end
