class CreateChatUsers < ActiveRecord::Migration
  def self.up
    create_table :chat_users do |t|
      t.integer :chatroom_id
      t.integer :user_id
      t.datetime :active_at
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :chat_users
  end
end
