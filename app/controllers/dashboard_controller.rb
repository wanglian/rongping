class DashboardController < ApplicationController
  before_filter :login_required
  
  # GET /
  # The default dashboard
  def index
  end
end
