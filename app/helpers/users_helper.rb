module UsersHelper
  
  # Link to a user (default is by name).
  def user_link(text, user = nil, html_options = nil)
    if user.nil?
      user = text
      text = user.name
    elsif user.is_a?(Hash)
      html_options = user
      user = text
      text = user.name
    end
    # We normally write link_to(..., user) for brevity, but that breaks
    # activities_helper_spec due to an RSpec bug.
    link_to(h(text), profile_path(user), html_options)
  end
end