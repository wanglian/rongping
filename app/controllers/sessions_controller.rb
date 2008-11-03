# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout 'login'
  
  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "Welcome back, {user}!"[:login_success_notice, self.current_user.login]
    else
      # TODO: (base_app) Add feature to resend the activation email, which might be caught as SPAM
      flash.now[:error] = "The login/password combination you provided is incorrect or your account has not yet been activated."[:login_failure_notice]
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out. Goodbye!"[:logout_notice]
    redirect_back_or_default('/')
  end
end
