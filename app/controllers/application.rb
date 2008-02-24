# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

# TODO: Search and Replace placeholder strings and replace them with sensible values
#   "base_app" 		  => "My Cool Application Name"
#   "base_app_url" 	=> "www.baseapp.com"			# Don't include http:// or a trailing slash
#   "company_name" 	=> "My Company Name"
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirement
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9fe6825f97cc334d88925fde5c4808a8'
end
