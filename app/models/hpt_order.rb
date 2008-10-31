require 'dbi'
class HptOrder < ActiveRecord::Base
  establish_connection :hpt
  set_table_name 'THptOrder'
end