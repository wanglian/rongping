module Admin::SettingsHelper
  def settings_field(setting)
    render :partial => "#{setting.field_type}", :locals => {:setting => setting}
  end
  
  def registration_enabled
    s(:registration_enabled) == 1
  end
  
end
