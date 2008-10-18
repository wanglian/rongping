# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirement
    
  helper :all # include all helpers, all the time
  
  Gibberish.current_language = 'zh-CN'
  
  # Return the value for a given setting
  def s(identifier)
    Setting.get(identifier)
  end
  helper_method :s

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9fe6825f97cc334d88925fde5c4808a8'
end
