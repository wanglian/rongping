# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081017120252) do

  create_table "departments", :force => true do |t|
    t.string "name"
  end

  create_table "orders", :force => true do |t|
    t.string   "order_number"
    t.date     "audit_at"
    t.string   "audit_number"
    t.string   "customer"
    t.string   "contact"
    t.integer  "manager_id"
    t.integer  "department_id"
    t.text     "memo"
    t.string   "account_name"
    t.text     "account_contact"
    t.integer  "product_id"
    t.string   "port_rate"
    t.float    "install_fee"
    t.float    "rent_fee"
    t.string   "a_access_type"
    t.string   "a_access_device"
    t.text     "a_address"
    t.text     "a_contact"
    t.string   "b_access_type"
    t.string   "b_access_device"
    t.text     "b_address"
    t.text     "b_contact"
    t.string   "state"
    t.integer  "confirm_user_id"
    t.datetime "confirm_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.string  "address"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "real_name"
    t.string   "location"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"
  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"

  create_table "settings", :force => true do |t|
    t.string   "label"
    t.string   "identifier"
    t.text     "description"
    t.string   "field_type",  :default => "string"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                   :default => "passive"
    t.datetime "deleted_at"
    t.string   "password_reset_code"
  end

end
