class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :event_attendees_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
