# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirement
    
  helper :all # include all helpers, all the time
  
  # Return the value for a given setting
  def s(identifier)
    Setting.get(identifier)
  end
  helper_method :s

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9fe6825f97cc334d88925fde5c4808a8'
  
  before_filter :set_language
  
  private
  def set_language
    Gibberish.current_language = cookies[:lang] || 'zh-CN'
    WillPaginate::ViewHelpers.pagination_options[:prev_label] = '&laquo; Previous'[:prev_page]
    WillPaginate::ViewHelpers.pagination_options[:next_label] = 'Next &raquo;'[:next_page]
  end
end
