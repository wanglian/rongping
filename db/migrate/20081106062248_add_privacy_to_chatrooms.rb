class AddPrivacyToChatrooms < ActiveRecord::Migration
  def self.up
    add_column :chatrooms, :privacy, :string, :default => 'Public'
  end

  def self.down
    remove_column :chatrooms, :privacy
  end
end
