class CreateMoves < ActiveRecord::Migration[5.1]
  def change
    create_table :moves do |t|
      t.string :game_state
      t.belongs_to :player
      t.belongs_to :game
      t.belongs_to :previous_move
      
      t.timestamps
    end
  end
end
