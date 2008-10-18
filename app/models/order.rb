class Order < ActiveRecord::Base
  ACCESS_TYPES = ['G.703', 'V.35', 'FE']
  STATES = ['NEW', 'IN PROGRESS', 'DONE']
  PORT_RATES = %w{64k 128k 256k 384k 512k 768k 1M 2M 4M 8M 10M 20M 30M 34M 45M 50M 60M 100M 155M}

  belongs_to :product
  belongs_to :department
  belongs_to :manager, :class_name => 'User', :foreign_key => 'manager_id'
  belongs_to :confirm_user, :class_name => 'User', :foreign_key => 'confirm_user_id'
  
  def product_category
    product.parent || product
  end
end
