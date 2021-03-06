class Chatroom < ActiveRecord::Base
  include ActivityLogger
  has_many :activities, :as => :item, :dependent => :destroy
  
  MAX_NAME = 100
  PRIVACIES = %w(Public Protected)
  
  belongs_to :user
  has_many :chats, :order => "created_at DESC"
  has_many :chat_users
  # has_many :online_users, :through => :chat_users, :source => :user, 
  #                           :conditions => ["chat_users.updated_at > ?", Time.zone.now-10.seconds], :order => "chat_users.updated_at asc"
  
  belongs_to :owner, :polymorphic => true
  
  validates_presence_of :title, :user
  validates_length_of   :title, :maximum => MAX_NAME
  
  def after_create
    log_activity if self.owner.nil?
  end
  
  def online_users # ugly
    self.chat_users.online.collect {|cu| cu.user}
  end
  
  def public?
    self.privacy == 'Public'
  end
  
  def protected?
    self.privacy == 'Protected'
  end
  
  def can_join?(current_user)
    if self.user == current_user
      true
    elsif self.owner
      self.owner.has_member? current_user
    elsif self.public?
      true
    elsif protected?
      self.chat_users.find_by_state_and_user_id 'active', current_user.id
    else
      false
    end
  end
  
  def apply(current_user)
    if chat_user = self.chat_users.find_by_user_id(current_user.id)
      chat_user.destroy
    end
    chat_user = self.chat_users.create :user => current_user
    chat_user.apply!
  end
  
  def update_online_user(current_user)
    if chat_user = self.chat_users.find_by_user_id(current_user.id)
      chat_user.update_attribute('updated_at', Time.now)
    end
  end
  
  def add_or_update_online_user(current_user)
    if chat_user = self.chat_users.find_by_user_id(current_user.id)
      chat_user.update_attribute('updated_at', Time.now)
    else
      chat_user = self.chat_users.create :user => current_user
      chat_user.activate!
    end
  end
  
  def self.per_page
    10
  end
  
end
