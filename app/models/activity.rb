class Activity < ActiveRecord::Base
  
  NUM_RECENT = 15
  
  belongs_to :user
  belongs_to :item, :polymorphic => true
  
  def self.find_recent
    find(:all, :order => "created_at DESC", :limit => NUM_RECENT)
  end
  
  def self.refresh(id, current_user)
    find(:all, :conditions => ['id > ? and user_id != ?', id, current_user], :order => 'created_at asc')
  end
  
end
