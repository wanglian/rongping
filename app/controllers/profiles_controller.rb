class ProfilesController < ApplicationController
  before_filter :find_profile
  before_filter :check_owner_access, :only => [:edit, :update]
  
  require_role :user, :only => [:edit, :update]
  
  def show
    # render show.html.erb
  end
  
  def edit
    # render edit.html.erb
  end
  
  def update    
    unless @profile.nil?
      @profile.update_attributes(params[:profile])
      flash[:notice] = "{object} has been succesfully {action}."[:object_action_notice, "Your profile"[], "updated"[]]
      redirect_to profile_url(@profile.user)
    else
      render :edit
    end
  end
  
  protected

  def find_profile
    begin
      @user = User.find(params[:id])
    rescue
      @user = nil
    end
    @profile = @user.nil? ? nil : @user.profile
  end    
  
  def check_owner_access
    redirect_to profile_url(params[:id]) if logged_in? && current_user != @user
  end
end
