class Order < ActiveRecord::Base
  ACCESS_TYPES = ['G.703', 'V.35', 'FE']
  STATES = ['NEW', 'IN PROGRESS', 'PENDING', 'DONE']
  PORT_RATES = %w{64k 128k 256k 384k 512k 768k 1M 2M 4M 8M 10M 20M 30M 34M 45M 50M 60M 100M 155M}
  
  validates_presence_of :product_id, :port_rate
  
  belongs_to :customer, :class_name => 'Organize', :foreign_key => 'customer_id'
  belongs_to :user, :class_name => 'Organize', :foreign_key => 'user_id'
  belongs_to :product
  belongs_to :manager, :class_name => 'User', :foreign_key => 'manager_id'
  belongs_to :confirm_user, :class_name => 'User', :foreign_key => 'confirm_user_id'
  
  has_many :order_progresses, :order => 'created_at DESC'
  
  def product_category
    product.parent || product
  end
  
  def customer_name
    customer ? customer.name : '直接用户'
  end
  
end
