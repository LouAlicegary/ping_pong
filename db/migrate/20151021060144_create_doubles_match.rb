class CreateDoublesMatch < ActiveRecord::Migration
  def change
    create_table :doubles_matches do |t|
      t.integer :winner_1
      t.integer :winner_2
      t.integer :loser_1
      t.integer :loser_2
    end
  end
end
