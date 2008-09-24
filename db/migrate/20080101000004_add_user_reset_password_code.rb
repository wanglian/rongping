class AddUserResetPasswordCode < ActiveRecord::Migration
  def self.up
    add_column :users, :password_reset_code, :string, :default => nil
  end

  def self.down
    remove_column :users, :password_reset_code
  end
end
