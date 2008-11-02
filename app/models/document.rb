class Document < ActiveRecord::Base
  include ActivityLogger
  
  MAX_TITLE_LENGTH = 40

  belongs_to :user
  has_attached_file :attachment
  
  validates_attachment_presence :attachment
  validates_presence_of :title, :user
  validates_length_of :title, :maximum => MAX_TITLE_LENGTH
  
  after_create :log_activity
end
