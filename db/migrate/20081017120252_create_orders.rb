class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :order_number
      t.date :audit_at
      t.string :audit_number
      t.integer :customer_id
      t.integer :user_id
      t.integer :manager_id #客户经理
      t.text :memo #备注
      
      t.string :account_name
      t.text :account_contact #联系信息
      
      t.integer :product_id
      t.string :port_rate
      t.float :install_fee
      t.float :rent_fee
      #合同期，要求工期，付款周期
      
      t.string :a_access_type
      t.string :a_access_device
      t.text :a_address
      t.text :a_contact
      
      t.string :b_access_type
      t.string :b_access_device
      t.text :b_address
      t.text :b_contact
      
      t.string :state # new/in progress/done
      t.integer :confirm_user_id
      t.datetime :confirm_at
      
      #attach
      t.string :circuit_id
      t.string :dsu_type
      t.string :dsu_sn
      t.string :router_type
      t.string :router_sn
      t.string :config_name
      t.string :node_name
      t.string :port_assignment
      
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
