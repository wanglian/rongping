class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities, :force => true do |t|
      t.integer :item_id
      t.string :item_type
      t.integer :user_id

      t.timestamps
    end
    
    add_index :activities, :item_id
    add_index :activities, :item_type
  end

  def self.down
    drop_table :activities
  end
end
