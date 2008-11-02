class EventAttendee < ActiveRecord::Base
  include ActivityLogger
  
  belongs_to :user
  belongs_to :event, :counter_cache => true
  validates_uniqueness_of :user_id, :scope => :event_id
  
  after_create :log_activity
end
