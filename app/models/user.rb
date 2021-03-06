require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken


  # Account Management
  has_and_belongs_to_many   :roles, :uniq => true
  has_and_belongs_to_many   :accounts

  has_one  :owned_account, :class_name => 'Account', :foreign_key => :owner_id

  # Project Management
  has_and_belongs_to_many   :portfolios
  has_and_belongs_to_many   :clients

  has_many  :portfolio_clients,   :through => :portfolios
  has_many  :portfolio_client_projects,  :through => :clients
  has_many  :client_projects, :through => :clients
  has_many  :todos,     :through => :projects


  validates_presence_of     :login
  validates_length_of       :login,       :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,       :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_presence_of     :first_name
  validates_format_of       :first_name,  :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :first_name,  :maximum => 100, :allow_nil => true

  validates_presence_of     :last_name
  validates_format_of       :last_name,   :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :last_name,   :maximum => 100, :allow_nil => true

  validates_presence_of     :email
  validates_length_of       :email,       :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,       :with => Authentication.email_regex, :message => Authentication.bad_email_message



  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :first_name, :last_name, :password, :password_confirmation,
    :description, :website, :gender, :twitter_username

  cattr_accessor :current_user

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end


  def name; "#{self.first_name} #{self.last_name}".squish; end


  def has_role?(role = :admin)
    @roles ||= self.roles
    self.roles.map(&:name).include?(role.to_s)
  end

  def owner?(item)
    case item.class
      when Project;   item.portfolio.account == self.owned_account
      when Client;    item.portfolio.account == self.owned_account
      when Portfolio; item.account == self.owned_account
      else; false;
    end      
  rescue
    false
  end


protected


end
