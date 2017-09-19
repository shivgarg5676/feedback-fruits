class Game < ApplicationRecord
  belongs_to :player1, class_name: "User"
  belongs_to :player2, class_name: "User", optional: true
  has_many :moves
  belongs_to :winner, class_name: 'User', optional: true
  include Workflow
  workflow do
    state :new do
      event :join, :transitions_to => :playing
    end
    state :playing do
      event :game_completed, :transitions_to => :game_completed
    end
    state :game_completed
  end

  def get_new_games(player)
    if(self.playing.length == 0)
      Game.create(:player1 => player)
    end
    self.
  end

end
