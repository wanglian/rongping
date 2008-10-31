class OrderProgress < ActiveRecord::Base
  include ActivityLogger
  
  PROGRESS_TYPE = ['General update', 'Need info', 'Due date change']
  
  belongs_to :user
  
  after_create :log_activity
  
  private
  
    def log_activity
      add_activities(:item => self, :user => user)
    end
end
