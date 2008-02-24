class CreateProfiles < ActiveRecord::Migration
  def self.up    
    create_table :profiles do |t|
      t.belongs_to :user

      t.string :real_name
      t.string :location
      t.string :website
      
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
    drop_table :profile_fields
  end
end
