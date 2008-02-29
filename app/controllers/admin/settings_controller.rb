class Admin::SettingsController < ApplicationController
  require_role :admin
  layout 'admin'
  
  def index
    # Render index.html.erb
  end
  
  def update
    # Do stuff
    
    redirect_to :action => :index
  end
end