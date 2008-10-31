class CreateOrderProgresses < ActiveRecord::Migration
  def self.up
    create_table :order_progresses do |t|
      t.integer :order_id
      t.string :progress_type
      t.text :note
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :order_progresses
  end
end
