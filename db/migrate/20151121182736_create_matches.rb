class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :match_type
      
      t.timestamps
    end
  end
end
