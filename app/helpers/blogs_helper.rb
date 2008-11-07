module BlogsHelper
  
  def blog_title(user = nil)
    if user.nil?
      'Blog'[]
    else
      "{user}'s {object}"[:whose_object, user.name, "blog"[]]
    end
  end
  
end
