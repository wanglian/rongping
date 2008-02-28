class SettingsGroup < ActiveRecord::Base
  validates_uniqueness_of :name
  
  has_many :settings
end
