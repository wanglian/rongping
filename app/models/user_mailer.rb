class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "http://base_app_url.host/activate/#{user.activation_code}"
  end
  
  def reset_password(user)
    setup_email(user)
    @subject += "Your password has been reset"
    @body[:url]  = "http://base_app_url.host/login"
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject += "Forgotten password instructions"
    @body[:url]  = "http://base_app_url.host/users/reset_password/#{user.password_reset_code}"
  end
  
  def forgot_login(user)
    setup_email(user)
    @subject += "Forgotten account login"
    @body[:url]  = "http://base_app_url.host/login"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://base_app_url.host/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "support@base_app_url.host"
      @subject     = "[base_app] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
