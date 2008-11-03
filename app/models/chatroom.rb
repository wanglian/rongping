class Chatroom < ActiveRecord::Base
  include ActivityLogger
  MAX_NAME = 100
  
  belongs_to :user
  has_many :chats, :order => "created_at DESC"
  has_many :chat_users
  has_many :online_users, :through => :chat_users, :source => :user, 
                          :conditions => ["active_at > ?", Time.now-10.seconds], :order => "active_at asc"
  
  validates_presence_of :title, :user
  validates_length_of   :title, :maximum => MAX_NAME
  
  after_create :log_activity
  
  def self.per_page
    10
  end
  
end
