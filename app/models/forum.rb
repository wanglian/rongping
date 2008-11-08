class Forum < ActiveRecord::Base
  MAX_TITLE = 50
  
  validates_presence_of :title
  validates_length_of   :title, :maximum => MAX_TITLE
  
  has_many :topics
end
