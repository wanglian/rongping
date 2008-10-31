class OrderProgressesController < ApplicationController
  before_filter :login_required
  before_filter :find_order, :except => [:index]
  
  def index
    @orders = Order.paginate_by_state 'IN PROGRESS', :page => params[:page], :order => 'created_at DESC'
  end
  
  def create
    @order_progress = OrderProgress.new params[:order_progress]
    @order_progress.user_id = current_user.id
    if @order.order_progresses << @order_progress
      respond_to do |format|
        format.js do 
          render :update do |page|
            page.replace_html "order-#{@order.id}-progresses-summary", progresses_summary(@order.order_progresses)
            page.insert_html :top, "order-#{@order.id}-progresses", :partial => 'order_progress', :object => @order_progress
            page["order-#{@order.id}-progress-form"].reset
            page.visual_effect :highlight, "progress-content-#{@order_progress.id}"
            page.visual_effect :pulsate, "progress-content-#{@order_progress.id}"
          end
        end
      end
    end
  end
  
  
  private
  def find_order
    @order = Order.find params[:order_id]
  end
  
end
