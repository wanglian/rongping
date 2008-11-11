module ForumsHelper
  
  def forum_title(forum)
    forum.owner ? "{owner}'s forum"[:whose_forum, h(forum.owner.name)] : 'Forum'[]
  end
  
  def can_reply?(forum)
    logged_in? && (forum.owner ? forum.owner.has_member?(current_user) : true)
  end
end
