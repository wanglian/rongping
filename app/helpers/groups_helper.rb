module GroupsHelper
  
  def show_topics?(group, user)
    group.public? || (logged_in? && group.has_member?(user))
  end
  
  def show_add_topic?(group, user)
    logged_in? && group.has_member?(user)
  end
  
  def show_members?(group, user)
    group.public? || (logged_in? && group.has_member?(user))
  end
  
  def show_chatroom?(group, user)
    logged_in? && group.has_member?(user) && group.chatroom
  end
  
  def show_requesting_uses?(group, user)
    logged_in? && group.user == current_user && !@group.requesting_members.empty?
  end
  
end
