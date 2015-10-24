class CreatePlayer < ActiveRecord::Migration
  
  def change
    create_table :players do |t|
      t.string :name
      t.decimal :mu, precision: 10, scale: 8
      t.decimal :sigma, precision: 10, scale: 8
    end
  end

end
