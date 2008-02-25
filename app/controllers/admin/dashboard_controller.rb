class Admin::DashboardController < ApplicationController
  require_role :admin
  
  def index
  end
end
