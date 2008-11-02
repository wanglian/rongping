class OrderProgress < ActiveRecord::Base
  include ActivityLogger
  
  PROGRESS_TYPE = ['General update', 'Need info', 'Due date change']
  
  belongs_to :user
  
  after_create :log_activity
end
