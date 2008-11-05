class CreateChats < ActiveRecord::Migration
  def self.up
    create_table :chats do |t|
      t.integer :user_id
      t.text :body
      t.integer :chatroom_id
      t.datetime :created_at
    end
    
    add_index :chats, :chatroom_id
    add_index :chats, :user_id
  end

  def self.down
    drop_table :chats
  end
end
