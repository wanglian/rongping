class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.string   "attachment_file_name"
      t.string   "attachment_content_type"
      t.integer  "attachment_file_size"
      
      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
