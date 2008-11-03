class DashboardController < ApplicationController
  before_filter :login_required unless guest_browse_enabled?
  
  # GET /
  # The default dashboard
  def index
  end
end
