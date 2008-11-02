class Document < ActiveRecord::Base
  include ActivityLogger
  
  MAX_TITLE_LENGTH = 40

  belongs_to :user

  validates_presence_of :title, :user
  validates_length_of :title, :maximum => MAX_TITLE_LENGTH
  
  has_attached_file :attachment
  
  after_create :log_activity
end
