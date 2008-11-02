class Chatroom < ActiveRecord::Base
  include ActivityLogger
  MAX_NAME = 100
  
  belongs_to :user
  has_many :chats
  
  validates_presence_of :title, :user
  validates_length_of   :title, :maximum => MAX_NAME
  
  after_create :log_activity
  
  def self.per_page
    10
  end
  
end
