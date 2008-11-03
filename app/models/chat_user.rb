class ChatUser < ActiveRecord::Base
  belongs_to :chatroom
  belongs_to :user
  
  def self.active(chatroom_id, user_id)
    if chat_user = ChatUser.find_by_chatroom_id_and_user_id(chatroom_id, user_id)
      chat_user.update_attribute('active_at', Time.now)
    else
      ChatUser.create :chatroom_id => chatroom_id, :user_id => user_id, :active_at => Time.now
    end
  end
  
end
