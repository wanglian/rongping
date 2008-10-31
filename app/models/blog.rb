class Blog < ActiveRecord::Base
  include ActivityLogger
  
  MAX_NAME = 100
  
  validates_presence_of :title
  validates_length_of   :title, :maximum => MAX_NAME
  
  belongs_to :user
  acts_as_commentable
  
  after_create :log_activity
  
  def self.per_page
    10
  end
  
  private
  
    def log_activity
      add_activities(:item => self, :user => user)
    end
end
