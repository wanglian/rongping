class AddStateToChatUsers < ActiveRecord::Migration
  def self.up
    add_column :chat_users, :state, :string, :default => 'passive'
  end

  def self.down
    remove_column :chat_users, :state
  end
end
