class CreateOrganizes < ActiveRecord::Migration
  def self.up
    create_table :organizes do |t|
      t.string :name
      t.text :contact
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :organizes
  end
end
