class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://#{Setting.get(:site_url)}/activate/#{user.activation_code}"
  end
  
  def reset_password(user)
    setup_email(user)
    @subject += "Your password has been reset"
    @body[:url]  = "http://#{Setting.get(:site_url)}/login"
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject += "Forgotten password instructions"
    @body[:url]  = "http://#{Setting.get(:site_url)}/users/reset_password/#{user.password_reset_code}"
  end
  
  def forgot_login(user)
    setup_email(user)
    @subject += "Forgotten account login"
    @body[:url]  = "http://#{Setting.get(:site_url)}/login"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{Setting.get(:site_url)}/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
      @subject     = "[#{Setting.get(:site_name)}] "
      @sent_on     = Time.now
      @body[:user] = user
      
      # Get Settings
      [:site_name, :company_name, :support_email, :support_name].each do |id|
        @body[id] = Setting.get(id)
      end
    end
end
