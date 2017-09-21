class MoveSerializer < ActiveModel::Serializer
  attributes :id,:state
  belongs_to :previous_move
  belongs_to :game
end
