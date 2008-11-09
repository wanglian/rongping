module ForumsHelper
  
  def forum_title(forum)
    forum.owner ? "{owner}'s forum"[:whose_forum, h(forum.owner.name)] : 'Forum'[]
  end
  
end
