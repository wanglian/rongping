class OrdersController < ApplicationController
  before_filter :login_required
  before_filter :find_order, :only => [:edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_order_customer, :auto_complete_for_order_account_name]
  
  # auto_complete_for :order, :customer
  # auto_complete_for :order, :account_name
  
  def index
    if current_user.has_role?('customer') && !current_user.has_role?('admin')
      @orders = Order.find :all, :conditions => ["customer_id = :id or user_id = :id", {:id => current_user.organize.id}]
      render :action => 'index_customer'
    end
    @orders = Order.paginate :page => params[:page], :order => 'created_at DESC'
  end
  
  def new
    @order = Order.new :account_contact => "联系人: \r\n电话: \r\n传真: \r\nEmail: ",
                       :a_address => "国家: \r\n省份: \r\n城市: \r\n区县: \r\n路名: \r\n路牌: \r\n楼宇: \r\n房号: \r\n建筑类型: ",
                       :a_contact => "姓名: \r\n电话: \r\n传真: \r\nEmail: ",
                       :b_address => "国家: \r\n省份: \r\n城市: \r\n区县: \r\n路名: \r\n路牌: \r\n楼宇: \r\n房号: \r\n建筑类型: ",
                       :b_contact => "姓名: \r\n电话: \r\n传真: \r\nEmail: "
  end
  
  def create
    @order = Order.new params[:order]
    @order.save
    
    unless @order.errors.empty?
      render :action => :new
    end
  end
  
  def edit
    
  end
  
  def update
    @order.update_attributes params[:order]
    if @order.errors.empty?
      flash[:notice] = '修改已保存'
      respond_to do |format|
        format.html {redirect_to :action => 'index'}
        format.js do
          render :update do |page|
            page.replace_html :status, flash[:notice]
            page.show :status
            page.visual_effect :pulsate, "status"
            flash.discard
          end
        end
      end
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @order.destroy
    
    respond_to do |format|
      format.html {redirect_to :action => 'index'}
      format.js {render :nothing => true}
    end
  end
  
  def auto_complete_for_order_customer
    @names = find_customers params[:order][:customer].downcase
    render :inline => "<%= auto_complete_result_string @names %>"
  end
  
  def auto_complete_for_order_account_name
    @names = find_customers params[:order][:account_name].downcase
    render :inline => "<%= auto_complete_result_string @names %>"
  end
  
  
  private
  def find_order
    @order = Order.find params[:id]
  end
  
  def find_customers(key)
    customers = Order.find :all, :group => 'customer', :conditions => ["lower(orders.customer) like ?", '%' + key + '%']
    accounts = Order.find :all, :group => 'account_name', :conditions => ["lower(orders.account_name) like ?", '%' + key + '%']
    names = Array.new
    customers.each {|c| names << c.customer} unless customers.empty?
    accounts.each {|a| names << a.account_name} unless accounts.empty?
    return names
    # return names.empty? ? find_customers('') : names
  end
  
end
