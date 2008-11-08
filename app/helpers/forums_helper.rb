module ForumsHelper
  
  def forum_title(forum)
    forum.owner ? "{owner}'s forum"[:whose_forum, h(forum.owner.name)] : 'Forum'[]
  end
  
  
  def link_to_owner(forum)
    return unless forum.owner
    
    owner = forum.owner
    case owner_type(owner)
    when 'Group'
      link_to "Back to {object}"[:back_to_object, owner.name], owner
    else
      raise "Invalid owner type #{owner_type(owner).inspect}"
    end
  end
  
  private
  def owner_type(owner)
    owner.class.name
  end
  
end
