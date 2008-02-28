class Admin::SettingsController < ApplicationController
  require_role :admin
  layout 'admin'
  
  def index
    @settingsgroups = SettingsGroup.find(:all, :order => 'name ASC')
  end
end