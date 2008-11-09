module ChatroomsHelper
  
  def chatroom_title(chatroom)
    chatroom.owner ? "{owner}'s chatroom"[:whose_chatroom, h(chatroom.owner.name)] : chatroom.title
  end
end
