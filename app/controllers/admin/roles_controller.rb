class Admin::RolesController < ApplicationController
  require_role :admin
  
  def index
    @roles = Role.find(:all, :order => 'name')
    # TODO: (base_app) Use will_paginate
    @users = User.find(:all, :order => 'login')
  end
end
