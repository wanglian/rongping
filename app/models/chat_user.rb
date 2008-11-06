class ChatUser < ActiveRecord::Base
  belongs_to :chatroom
  belongs_to :user
  named_scope :online, lambda { {:conditions => ["updated_at > ?", 10.seconds.ago]}}
  
  acts_as_state_machine :initial => :passive
  state :passive
  state :requesting
  state :active
  
  event :apply do
    transitions :from => :passive, :to => :requesting 
  end
  
  event :activate do
    transitions :from => [:passive, :requesting], :to => :active 
  end
end
