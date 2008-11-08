class GroupUser < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  named_scope :recent, lambda {|limit| {:conditions => {:state => 'active'}, :order => 'updated_at DESC', :limit => limit}}
  named_scope :requests, :conditions => {:state => 'requesting'}, :order =>'updated_at DESC'
  
  acts_as_state_machine :initial => :passive
  state :passive
  state :requesting
  state :active
  
  event :apply do
    transitions :from => :passive, :to => :requesting 
  end
  
  event :activate do
    transitions :from => [:passive, :requesting], :to => :active 
  end
end
