class Account < ActiveRecord::Base

  belongs_to  :portfolio
  belongs_to  :client

  has_and_belongs_to_many   :users

  has_many    :portfolios
  belongs_to  :owner, :class_name => 'User'


  validates_presence_of     :company
  validates_length_of       :company,   :maximum => 100
  validates_length_of       :company,   :minimum => 3

  validates_presence_of     :email
  validates_length_of       :email,     :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,     :with => Authentication.email_regex, :message => Authentication.bad_email_message

  # validates_presence_of     :owner_id

  attr_accessible :company, :email


  before_create :generate_slug
  # before_save :ensure_user_account
  after_create  :create_portfolio


  def slug; self.slug || self.id; end

  def add_user(user); self.users << user; end
  def remove_user(user); self.users.delete(user); end


protected

  # def ensure_user_account
  #   if self.owner.blank?
  #     user_pass = String.new.random(:limit => 12, :random_length => true)
  #     STDERR.puts "New User Password: #{user_pass}"
  #     self.owner = User.create(:email => self.email, :login => self.email, :password => user_pass, :password_confirmation => user_pass)
  #   end
  # end


  def create_portfolio
    if self.option_portfolios_count == 1
      portfolio = Portfolio.create(:account_id => self.id, :title => self.company, :description => '')
      portfolio.add_user(self.owner)
    end
  end

  def generate_slug
    invalid, i, base_slug = true, 0, self.company.downcase.gsub(/[\~\!\@\#\$\%\^\&\*\(\)\_\+\=\`\{\}\|\:\"\<\>\?\,\.\/\;\'\[\]\\\'\"\`]/, '').gsub(/\s/, '-')
    base_slug = "#{base_slug}-" unless base_slug =~ /[A-Z]/i
    slug = base_slug
    loop {
      obj = Account.find_by_url_slug(slug) rescue nil
      break if obj.blank?
      i += 1
      slug = "#{base_slug}-#{i}"
    }
    self.url_slug = slug
  end

end
