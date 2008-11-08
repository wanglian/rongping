class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
    
    Forum.create :title => 'Forum'
    
    add_column :topics, :forum_id, :integer, :default => 1
  end

  def self.down
    drop_table :forums
    remove_column :topics, :forum_id
  end
end
