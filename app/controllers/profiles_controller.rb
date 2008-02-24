class ProfilesController < ApplicationController
  before_filter :find_user
  
  # TODO: (base_app) enable inline editing of the profile for the owner
  
  def show
    @profile = @user.nil? ? nil : @user.profile
  end
  
  def edit
    redirect_to profile_url(params[:id]) if logged_in? && current_user != @user
  end
  
  def update
    redirect_to profile_url(params[:id]) if logged_in? && current_user != @user
    # TODO: (base_app) Write profile update code
  end
  
  protected

  def find_user
    @user = User.find(params[:id])
  rescue
    @user = nil
  end    
end
