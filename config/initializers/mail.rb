require 'smtp_tls'

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "homev2.com",
  :authentication => :plain,
  :user_name => "system.homev2@gmail.com",
  :password => "superhomev2"
}