class AddDefaultAdminUser < ActiveRecord::Migration
  def self.up
    # Setup default roles
    admin_role = Role.create(:name => 'admin')
    user_role  = Role.create(:name => 'user')
    
    # Add a default administrator
    admin = User.create(
      :login => 'admin', 
      :password => 'base_app', 
      :password_confirmation => 'base_app',
      :email => 'admin@test.host')
      
    admin.roles << admin_role
    admin.activate!
  end

  def self.down
  end
end
