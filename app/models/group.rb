class Group < ActiveRecord::Base
  include ActivityLogger
  
  MAX_NAME = 50
  PRIVACIES = %w(Public Protected)
  
  belongs_to :user
  has_many :group_users
  has_many :members, :through => :group_users, :source => :user, :conditions => "group_users.state = 'active'"
  has_many :requesting_members, :through => :group_users, :source => :user, :conditions => "group_users.state = 'requesting'"
    
  validates_presence_of :name, :user
  validates_length_of   :name, :maximum => MAX_NAME
  
  has_attached_file :logo,
                    :styles => {:medium => "240>", :small => "72>"},
                    :default_url => "/images/default_:style_avatar.png",
                    :default_style => :small

  def public?
    self.privacy == 'Public'
  end
  
  def protected?
    self.privacy == 'Protected'
  end
  
  def has_member?(u)
    self.members.include?(u)
  end
  
  def has_requesting?(u)
    self.requesting_members.include?(u)
  end
  
  def add_member(u)
    return if has_member?(u)
    gu = self.group_users.find_by_user_id u.id
    gu.destroy if gu
    
    gu = self.group_users.create(:user => u)
    
    gu.activate! if public?
    gu.apply! if protected?
  end
  
  def accept_member(u)
    gu = self.group_users.find_by_user_id u.id
    return false unless gu.state == 'requesting'
    
    gu.activate!
  end
  
  def reject_member(u)
    gu = self.group_users.find_by_user_id u.id
    gu.destroy if gu.state == 'requesting'
  end
  
  def after_create
    Forum.create :title => self.name, :owner => self
    Chatroom.create :title => self.name, :owner => self, :user => self.user
    log_activity
  end
  
end
