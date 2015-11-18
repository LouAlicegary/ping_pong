class CreateSinglesMatch < ActiveRecord::Migration
  def change
    create_table :singles_matches do |t|
      t.integer :winner
      t.integer :loser
      t.timestamps
    end
  end
end
