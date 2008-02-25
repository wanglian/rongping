class Admin::DashboardController < ApplicationController
  require_role :admin
  layout 'admin'
  
  def index
  end
end
