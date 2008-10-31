class Activity < ActiveRecord::Base
  
  NUM_RECENT = 15
  
  belongs_to :user
  belongs_to :item, :polymorphic => true
  
  def self.find_recent
    find(:all, :order => "created_at DESC", :limit => NUM_RECENT)
  end
end
