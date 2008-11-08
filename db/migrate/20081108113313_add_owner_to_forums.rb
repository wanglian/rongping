class AddOwnerToForums < ActiveRecord::Migration
  def self.up
    add_column :forums, :owner_type, :string
    add_column :forums, :owner_id, :integer
  end

  def self.down
    remove_column :forums, :owner_type
    remove_column :forums, :owner_id
  end
end
