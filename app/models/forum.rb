class Forum < ActiveRecord::Base
  MAX_TITLE = 50
  
  validates_presence_of :title
  validates_length_of   :title, :maximum => MAX_TITLE
  
  has_many :topics
  belongs_to :owner, :polymorphic => true
  
  def self.find_by_owner(o)
    find_by_owner_type_and_owner_id o.class.name, o.id
  end
  
end
