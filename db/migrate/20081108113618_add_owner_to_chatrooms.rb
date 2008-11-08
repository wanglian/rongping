class AddOwnerToChatrooms < ActiveRecord::Migration
  def self.up
    add_column :chatrooms, :owner_type, :string
    add_column :chatrooms, :owner_id, :integer
  end

  def self.down
    remove_column :chatrooms, :owner_type
    remove_column :chatrooms, :owner_id
  end
end
