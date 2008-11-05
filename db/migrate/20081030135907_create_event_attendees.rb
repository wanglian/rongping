class CreateEventAttendees < ActiveRecord::Migration
  def self.up
    create_table :event_attendees do |t|
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end
    
    add_index :event_attendees, :event_id
  end

  def self.down
    drop_table :event_attendees
  end
end
