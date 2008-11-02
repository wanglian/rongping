class Chat < ActiveRecord::Base
  belongs_to :user
  belongs_to :chatroom
  
  validates_presence_of :body, :user, :chatroom
  
  def self.refresh(id, room_id, current_user)
    find(:all, :order => 'id desc', :include => :user, :conditions => ['id > ? and chatroom_id = ? and user_id != ?', id, room_id, current_user])
  end
end
