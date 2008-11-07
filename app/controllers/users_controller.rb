class UsersController < ApplicationController
  before_filter :login_required, :only => [:index, :refresh_activities] unless guest_browse_enabled?
  before_filter :find_user, 
    :only => [:profile, 
              :destroy, 
              :edit_password,   :update_password, 
              :edit_email,      :update_email,
              :edit_time_zone,  :update_time_zone,
              :update_avatar ]
  
  layout 'login' #, :except => [:edit_password, :update_password]
  # layout 'application', :only => [:index, :show]
  
  def index
    if params[:search]
      @users = User.search params[:search], :order => "created_at DESC"
    else
      @users = User.paginate :order => "created_at DESC", :page => params[:page]
    end
    
    render :layout => 'application'
  end
  
  # render new.rhtml
  def new
  end

  def troubleshooting
    # Render troubleshooting.html.erb
    render :layout => 'login'
  end

  def clueless
    # These users are beyond our automated help...
    render :layout => 'login'
  end

  def forgot_login
    if request.put?
      begin
        @user = User.find_by_email(params[:email], :conditions => ['NOT state = ?', 'deleted'])
      rescue
        @user = nil
      end
      
      if @user.nil?
        flash.now[:error] = 'No account was found with that email address.'
      else
        UserMailer.deliver_forgot_login(@user)
      end
    else
      # Render forgot_login.html.erb
    end
    
    render :layout => 'login'
  end

  def forgot_password
    if request.put?
      @user = User.find_by_login_or_email(params[:email_or_login])

      if @user.nil?
        flash.now[:error] = 'No account was found by that login or email address.'
      else
        @user.forgot_password if @user.active?
      end
    else
      # Render forgot_password.html.erb
    end
    
    render :layout => 'login'
  end
  
  def reset_password
    begin
      @user = User.find_by_password_reset_code(params[:password_reset_code])
    rescue
      @user = nil
    end
    
    unless @user.nil? || !@user.active?
      @user.reset_password!
    end
    
    render :layout => 'login'
  end

  def create
    cookies.delete :auth_token
    @user = User.new(params[:user])
    raise ActiveRecord::RecordInvalid.new(@user) unless @user.valid?
    @user.register!
    
    redirect_back_or_default('/')
    flash[:notice] = "Thanks for signing up!<br />You will receive an email in a few minutes with further instructions on how to activate your account."[:sign_up_notice]
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def activate
    self.current_user = params[:activation_code].blank? ? :false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Your account is now ready.<br />Thanks for signing up!"[:user_activate_notice]
    end
    redirect_back_or_default('/')
  end
  
  def edit_password
    # render edit_password.html.erb
  end
  
  def update_password    
    if current_user == @user
      current_password, new_password, new_password_confirmation = params[:current_password], params[:new_password], params[:new_password_confirmation]
      
      if User.encrypt(current_password, @user.salt) == @user.crypted_password
        if new_password == new_password_confirmation
          if new_password.blank? || new_password_confirmation.blank?
            flash[:error] = "You cannot set a blank password."
            redirect_to edit_password_user_url(@user)
          else
            @user.password = new_password
            @user.password_confirmation = new_password_confirmation
            @user.save
            flash[:notice] = "Your password has been updated."
            redirect_to profile_url(@user)
          end
        else
          flash[:error] = "Your new password and it's confirmation don't match."
          redirect_to edit_password_user_url(@user)
        end
      else
        flash[:error] = "Your current password is not correct. Your password has not been updated."
        redirect_to edit_password_user_url(@user)
      end
    else
      flash[:error] = "You cannot update another user's password!"
      redirect_to edit_password_user_url(@user)
    end
  end
  
  def edit_email
    # render edit_email.html.erb
  end
  
  def update_email
    if current_user == @user
      if @user.update_attributes(:email => params[:email])
        flash[:notice] = "Your email address has been updated."
        redirect_to profile_url(@user)
      else
        flash[:error] = "Your email address could not be updated."
        redirect_to edit_email_user_url(@user)
      end
    else
      flash[:error] = "You cannot update another user's email address!"
      redirect_to edit_email_user_url(@user)
    end
  end  
  
  def edit_time_zone
    
  end
  
  def update_time_zone
    if current_user == @user
      if @user.update_attributes(:time_zone => params[:user][:time_zone])
        flash[:notice] = "Your time zone has been updated."
        redirect_to profile_url(@user)
      else
        flash[:error] = "Your time zone could not be updated."
        redirect_to edit_time_zone_user_url(@user)
      end
    else
      flash[:error] = "You cannot update another user's time zone!"
      redirect_to edit_time_zone_user_url(@user)
    end
  end
  
  def update_avatar
    if @user.update_attributes(params[:user])
      respond_to do |format|
        format.html
        format.js do
          responds_to_parent do
            render :update do |page|
              page.replace_html :avatar, avatar_for(@user, "medium")
              page["avatar-form"].reset
            end
          end
        end
      end
    end
  end
  
  def refresh_activities
    activity_id = session[:activity_id] || Activity.find(:last).id
    @activities = Activity.refresh activity_id, current_user
    puts @activities.size
    render :update do |page|
      unless @activities.empty?
        session[:activity_id] = @activities.last.id
        @activities.each do |activity|
          page << "if ($('activity-#{activity.id}')){"
          page << '}else{'
          page.insert_html :top, 'activitiess', :partial => 'shared/activity_mini_item', :object => activity
          page.visual_effect :highlight, "activity-#{activity.id}"
          page << '}'
        end
      else
        render :nothing => true
      end
    end
  end
  
  def choose_lang
    cookies[:lang] = params[:lang] == 'en-US' ? 'en-US' : 'zh-CN'
    render :nothing => true
  end
  
  protected

  def find_user
    @user = User.find(params[:id])
  end

end
