class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.belongs_to :player1
      t.belongs_to :player2
      t.belongs_to :winner
      t.string :workflow_state
      t.timestamps
    end
  end
end
