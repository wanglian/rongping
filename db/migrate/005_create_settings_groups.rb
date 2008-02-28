class CreateSettingsGroups < ActiveRecord::Migration
  def self.up
    create_table :settings_groups, :force => true do |t|
      t.string :name
      t.integer :position, :default => 0
    end
    
    SettingsGroup.create(:name => 'General')
  end

  def self.down
    drop_table :settings_groups
  end
end
