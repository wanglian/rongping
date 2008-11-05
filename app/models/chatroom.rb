class Chatroom < ActiveRecord::Base
  include ActivityLogger
  MAX_NAME = 100
  
  belongs_to :user
  has_many :chats, :order => "created_at DESC"
  has_many :chat_users
  has_many :online_users, :through => :chat_users, :source => :user, 
                          :conditions => ["chat_users.updated_at > ?", Time.now.utc-10.seconds], :order => "chat_users.updated_at asc"
  
  validates_presence_of :title, :user
  validates_length_of   :title, :maximum => MAX_NAME
  
  after_create :log_activity
  
  def add_or_update_online_user(user)
    if chat_user = self.chat_users.find_by_chatroom_id_and_user_id(self.id, user)
      chat_user.update_attribute('updated_at', Time.now)
    else
      self.online_users << user
    end
  end
  
  def self.per_page
    10
  end
  
end
