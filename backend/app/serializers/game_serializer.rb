class GameSerializer < ActiveModel::Serializer
  attributes :id, :workflow_state
  belongs_to :player1
  belongs_to :player2
  belongs_to :winner
  has_many :moves
  belongs_to :last_move
end
