module ProfilesHelper
  
  def avatar_for(user, size=nil, options={})
    image_tag(user.avatar.url(size), options)
  end
  
end
