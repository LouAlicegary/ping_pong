class RemoveDoublesMatches < ActiveRecord::Migration
  def change
    drop_table :doubles_matches
  end
end
