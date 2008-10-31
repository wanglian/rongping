module ProfilesHelper
  
  def avatar_for(user, size=nil)
    image_tag(user.avatar.url(size))
  end
  
end
