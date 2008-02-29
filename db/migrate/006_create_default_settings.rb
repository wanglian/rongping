class CreateDefaultSettings < ActiveRecord::Migration
  def self.up
    Setting.create(
      :label => "Site name",
      :identifier => 'site_name',
      :description => 'The name of your application. This name will be used to brand your entire application.',
      :field_type => 'string',
      :value => "BaseAPP"
    )
    
    Setting.create(
      :label => "Company name",
      :identifier => 'company_name',
      :description => "Your company's name. It will be used to identify you as the owner of the application.",
      :field_type => 'string',
      :value => "Ariejan.net"
    )
    
    Setting.create(
      :label => "Site URL",
      :identifier => 'site_url',
      :description => "The FQDN of your site. Don't include http:// or a trailing slash. If your application uses more than one FQDN, specify the primary one.",
      :field_type => 'string',
      :value => "baseapp.com"
    )
    
    Setting.create(
      :label => "Support name",
      :identifier => 'support_name',
      :description => 'How do you reference to your support department? This will be used to direct users to your support department.',
      :field_type => 'string',
      :value => "Support"
    )
    
    Setting.create(
      :label => "Support email address",
      :identifier => 'support_email',
      :description => 'What is your support email address? This address will be shown to users for them to email support requests.  ',
      :field_type => 'string',
      :value => "support@baseapp.com"
    )
  end

  def self.down
    Setting.delete_all
  end
end
