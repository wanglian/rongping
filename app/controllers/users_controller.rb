class UsersController < ApplicationController
  before_filter :find_user, :only => [:profile, :destroy]
  
  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    @user = User.new(params[:user])
    raise ActiveRecord::RecordInvalid.new(@user) unless @user.valid?
    @user.register!
    
    redirect_back_or_default('/')
    flash[:notice] = "Thanks for signing up!<br />You will receive an email in a few minutes with further instructions on how to activate your account."
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def activate
    self.current_user = params[:activation_code].blank? ? :false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Your account is now ready.<br />Thanks for signing up!"
    end
    redirect_back_or_default('/')
  end

protected
  def find_user
    @user = User.find(params[:id])
  end

end
