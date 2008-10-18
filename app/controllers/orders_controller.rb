class OrdersController < ApplicationController
  def index
    @orders = Order.find :all
  end
  
  def new
  
  end
  
  def create
    @order = Order.new params[:order]
    @order.save
    
    unless @order.errors.empty?
      render :action => :new
    end
  end
end
