class CreateDefaultSettings < ActiveRecord::Migration
  def self.up
    @sg = SettingsGroup.find_by_name('General')
    
    Setting.create(
      :label => "Site name",
      :identifier => 'site_name',
      :description => 'The name of your application',
      :value => "BaseAPP",
      :settings_group => @sg
    )
    
    Setting.create(
      :label => "Company name",
      :identifier => 'company_name',
      :description => "Your company's name",
      :value => "Ariejan.net",
      :settings_group => @sg
    )
    
    Setting.create(
      :label => "Site URL",
      :identifier => 'site_url',
      :description => "The FQDN of your site. Don't include http:// or a trailing slash",
      :value => "baseapp.com",
      :settings_group => @sg
    )
    
    @ss = SettingsGroup.create(:name => 'Support')
    
    Setting.create(
      :label => "Support name",
      :identifier => 'support_name',
      :description => 'What is the support department called',
      :value => "BaseAPP Support",
      :settings_group => @ss
    )
    
    Setting.create(
      :label => "Support email address",
      :identifier => 'support_email',
      :description => 'The email address users can use to send support questions to',
      :value => "support@baseapp.com",
      :settings_group => @ss
    )
  end

  def self.down
    Setting.delete_all
  end
end
