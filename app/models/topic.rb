class Topic < ActiveRecord::Base
  include ActivityLogger
  
  MAX_NAME = 100
  NUM_RECENT = 6
  
  validates_presence_of :name
  validates_length_of   :name, :maximum => MAX_NAME
  
  acts_as_commentable
  belongs_to :user
  
  after_create :log_activity
  
  # sphinx
  define_index do
    indexes :name
    indexes comments.comment, :as => :comments
    
    has created_at
  end
  
  def self.find_recent
    find(:all, :order => "created_at DESC", :limit => NUM_RECENT)
  end
  
  def self.per_page
    10
  end
end
