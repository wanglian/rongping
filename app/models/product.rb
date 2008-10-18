class Product < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Product', :foreign_key => 'parent_id'
end
