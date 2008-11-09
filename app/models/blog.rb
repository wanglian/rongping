class Blog < ActiveRecord::Base
  include ActivityLogger
  
  MAX_NAME = 100
  
  validates_presence_of :title
  validates_length_of   :title, :maximum => MAX_NAME
  
  belongs_to :user
  acts_as_commentable
  acts_as_taggable
  
  after_create :log_activity
  
  # sphinx
  define_index do
    indexes title
    indexes body
    
    has created_at, user_id
  end
  
  def self.per_page
    10
  end
end
