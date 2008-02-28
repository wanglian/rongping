class Setting < ActiveRecord::Base
  validates_presence_of :label
  validates_uniqueness_of :label, :scope => :settings_group_id
  validates_uniqueness_of :identifier
  
  belongs_to :settings_group
  
  # Story any kind of object in the value field.
  # This is nice, but you should also make it editable through admin/settings
  serialize :value
  
  # Return the value for a setting
  def self.get(identifier)
    identifier = identifier.to_s if identifier.is_a?(Symbol)
    
    begin
      setting = find_by_identifier(identifier)
    rescue
      setting = nil
    end
    
    setting.nil? ? "" : setting.value
  end
end
