require 'digest/sha1'
class User < ActiveRecord::Base
  
  has_and_belongs_to_many :roles
  has_one :profile
  
  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end

  # Virtual attribute for the unencrypted password
  attr_accessor :password
  
  # Per page pagination
  cattr_reader :per_page
  @@per_page = 25

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 2..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password
  
  after_create :create_environment
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  acts_as_state_machine :initial => :pending
  state :passive
  state :pending, :enter => :make_activation_code
  state :unactivated
  state :active,  :enter => :do_activate
  state :suspended
  state :deleted, :enter => :do_delete

  event :register do
    transitions :from => :passive, :to => :pending, :guard => Proc.new {|u| !(u.crypted_password.blank? && u.password.blank?) }
  end
  
  event :activate do
    transitions :from => :pending, :to => :active 
  end
  
  event :send_activation do
    transitions :from => :pending, :to => :unactivated
  end
  
  event :suspend do
    transitions :from => [:passive, :pending, :active, :unactivated], :to => :suspended
  end
  
  event :delete do
    transitions :from => [:passive, :pending, :active, :unactivated, :suspended], :to => :deleted
  end

  event :unsuspend do
    transitions :from => :suspended, :to => :active,  :guard => Proc.new {|u| !u.activated_at.blank? }
    transitions :from => :suspended, :to => :pending, :guard => Proc.new {|u| u.activated_at.blank? && u.activation_code.blank? }
    transitions :from => :suspended, :to => :unactivated, :guard => Proc.new {|u| u.activated_at.blank? && !u.activation_code.blank? }
    transitions :from => :suspended, :to => :passive
  end

  # Creates a new password for the user, and notifies him with an email
  def reset_password!
    password = PasswordGenerator.random_pronouncable_password(3)
    self.password = password
    self.password_confirmation = password
    self.password_reset_code = nil
    save
    
    UserMailer.deliver_reset_password(self)
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_in_state :first, :active, :conditions => {:login => login} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def forgot_password
    self.make_password_reset_code
    save
    UserMailer.deliver_forgot_password(self)
  end
  
  def self.find_by_login_or_email(login_or_email)
    find(:first, :conditions => ['login = ? OR email = ?', login_or_email, login_or_email])
  rescue
    nil
  end
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_activation_code
      self.deleted_at = nil
      self.activation_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
    def make_password_reset_code
      self.password_reset_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
    def do_delete
      self.deleted_at = Time.now.utc
    end

    def do_activate
      self.activated_at = Time.now.utc
      self.deleted_at = self.activation_code = nil
    end
    
    def create_environment
      # Give the user a profile
      self.profile = Profile.create
      
      # Give the defaul 'user' role
      self.roles << Role.find_by_name('user')
    end
end
