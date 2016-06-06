class CreateMatchPlayers < ActiveRecord::Migration
  def change
    create_table :match_players do |t|

      t.integer :match_id
      t.integer :player_id
      t.integer :outcome
      t.decimal :mu_pre
      t.decimal :mu_post
      t.decimal :sigma_pre
      t.decimal :sigma_post

      t.timestamps null: false
    end
  end
end
