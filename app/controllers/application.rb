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
  def self.guest_browse_enabled?
    Setting.get(:guest_browse_enabled) == 1
  end
  def registration_enabled?
    s(:registration_enabled) == 1
  end
  def search_enabled?
    s(:search_enabled) == 1
  end
  
  helper_method :s, :registration_enabled?, :search_enabled?

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9fe6825f97cc334d88925fde5c4808a8'
  
  before_filter :set_language, :set_user_time_zone
  
  private
  def set_language
    Gibberish.current_language = cookies[:lang] || 'en-US'
    WillPaginate::ViewHelpers.pagination_options[:prev_label] = '&laquo; Previous'[:prev_page]
    WillPaginate::ViewHelpers.pagination_options[:next_label] = 'Next &raquo;'[:next_page]
  end
  
  def set_user_time_zone
    Time.zone = current_user.time_zone if logged_in?
  end
  
  def current_action
    request.path_parameters[:action]
  end
  
  def current_controller
    request.path_parameters[:controller]
  end
  
  def can_edit
    redirect_to root_path and return false unless logged_in?
    klass = current_controller.singularize.classify.constantize
    @item = klass.find(params[:id])
    if current_controller == "users"
      redirect_to root_path and return false unless current_user.admin? || (current_user == @item)
    else
      redirect_to root_path and return false unless current_user.admin? || (current_user == @item.user)
    end
  end
      
  def can_edit?(current_item)
    return false unless logged_in?
    if current_controller == "users"
      return current_user.admin? || (current_user == current_item) 
    else
      return current_user.admin? || (current_user.id == current_item.user_id) 
    end
  end
end
