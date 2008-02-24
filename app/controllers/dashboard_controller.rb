class DashboardController < ApplicationController
  # GET /
  # The default dashboard
  def index
    flash[:notice]  = "This is a flash notice. Remove it from DashboardController#index"
    flash[:warning] = "This is a flash warning. Remove it from DashboardController#index"
    flash[:error]   = "This is a flash error. Remove it from DashboardController#index"
  end
end
