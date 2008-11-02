class Event < ActiveRecord::Base
  include ActivityLogger

  MAX_TITLE_LENGTH = 40

  acts_as_commentable
  belongs_to :user
  has_many :event_attendees
  has_many :attendees, :through => :event_attendees, :source => :user

  validates_presence_of :title, :start_time, :user
  validates_length_of :title, :maximum => MAX_TITLE_LENGTH
  
  named_scope :user_events, 
              lambda { |user| { :conditions => ["user_id = ?", user.id] } }
  
  named_scope :period_events,
              lambda { |date_from, date_until| { :conditions => ['start_time >= ? and start_time <= ?',
                                                 date_from, date_until] } }

  after_create :log_activity
  
  def self.monthly_events(date)
    self.period_events(date.beginning_of_month, date.to_time.end_of_month)
  end
  
  def self.daily_events(date)
    self.period_events(date.beginning_of_day, date.to_time.end_of_day)
  end

  def validate
    if end_time
      unless start_time <= end_time
        errors.add(:start_time, "can't be later than End Time")
      end
    end
  end
  
  def attend(user)
    self.event_attendees.create!(:user => user)
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def unattend(user)
    if event_attendee = self.event_attendees.find_by_user_id(user)
      event_attendee.destroy
    else
      nil
    end
  end

  def attending?(user)
    self.attendee_ids.include?(user[:id])
  end
  
end
