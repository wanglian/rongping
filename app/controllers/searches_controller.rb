class SearchesController < ApplicationController
  
  before_filter :login_required

  def index
    redirect_to(root_url) and return if params[:q].nil?
    
    query = params[:q].strip.inspect
    model = strip_admin(params[:model])
    page  = params[:page] || 1

    unless %(User).include?(model)
      flash[:error] = "Invalid search"
      redirect_to root_url and return
    end

    if query.blank?
      @results = [].paginate
    else
      if model == "User"
        #TODO
      end
    end
  end
  
  private
    
    # Strip off "Admin::" from the model name.
    # This is needed for, e.g., searches in the admin view
    def strip_admin(model)
      model.split("::").last
    end
end
