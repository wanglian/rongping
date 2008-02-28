class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings, :force => true do |t|
      t.belongs_to :settings_group
      t.string :label
      t.string :identifier
      t.string :description
      t.text   :value

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
