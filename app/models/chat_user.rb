class ChatUser < ActiveRecord::Base
  belongs_to :chatroom
  belongs_to :user
  named_scope :online, lambda { {:conditions => ["updated_at > ?", 10.seconds.ago]}}
  
end
