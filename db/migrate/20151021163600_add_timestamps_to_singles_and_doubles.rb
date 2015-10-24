class AddTimestampsToSinglesAndDoubles < ActiveRecord::Migration
  def change

    add_column :singles_matches, :created_at, :DateTime
    add_column :singles_matches, :updated_at, :DateTime

    add_column :doubles_matches, :created_at, :DateTime
    add_column :doubles_matches, :updated_at, :DateTime

  end
end
