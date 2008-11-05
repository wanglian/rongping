class ChatUser < ActiveRecord::Base
  belongs_to :chatroom
  belongs_to :user
  
end
