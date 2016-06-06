class RemoveSinglesMatches < ActiveRecord::Migration
  def change
    drop_table :singles_matches
  end
end
