class CreateChatUsers < ActiveRecord::Migration
  def self.up
    create_table :chat_users do |t|
      t.integer :chatroom_id
      t.integer :user_id
      
      t.timestamps
    end
    
    add_index :chat_users, :chatroom_id
  end

  def self.down
    drop_table :chat_users
  end
end
