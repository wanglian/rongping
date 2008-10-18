class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.integer :parent_id
      t.string :address
    end
  end

  def self.down
    drop_table :products
  end
end
