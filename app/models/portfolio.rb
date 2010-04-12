class Portfolio < ActiveRecord::Base

  has_and_belongs_to_many  :users
  belongs_to  :account

  has_many  :clients
  has_many  :projects

  has_many  :messages
  has_many  :todos
  has_many  :timesheets
  has_many  :comments
  has_many  :notifications, :order => 'created_at DESC, id DESC', :conditions => "note_type IN(#{Notification::NOTE_TYPES.map{|n| "'#{n}'"}.join(', ')})"


  validates_presence_of     :title
  validates_length_of       :title,   :maximum => 100, :allow_nil => true


  before_create :generate_slug

  after_create  { |portfolio| portfolio.create_notification(:note_type => 'portfolio_created') }
  after_update  { |portfolio| portfolio.create_notification(:note_type => 'portfolio_updated') }
  after_destroy { |portfolio| portfolio.create_notification(:note_type => 'portfolio_deleted') }


  def slug; self.url_slug || self.id; end

  def add_user(user)
    self.users << user
    create_notification(:note_type => 'user_added', :subject_type => user.class.to_s, :subject_id => user.id)
  end

  def remove_user(user)
    self.users.delete(user)
    create_notification(:note_type => 'user_removed', :subject_type => user.class.to_s, :subject_id => user.id)
  end

  def create_notification(*opts)
    options = {:portfolio_id => self.id, :item_type => self.class.to_s, :item_id => self.id}.merge( opts.extract_options! )
    options[:user_id] = User.current_user.id
    Notification.create(options)
  end


protected

  def generate_slug
    invalid, i, base_slug = true, 0, self.title.downcase.gsub(/[\~\!\@\#\$\%\^\&\*\(\)\_\+\=\`\{\}\|\:\"\<\>\?\,\.\/\;\'\[\]\\\'\"\`]/, '').gsub(/\s/, '-')
    base_slug = "#{base_slug}-" unless base_slug =~ /[A-Z]/i
    slug = base_slug
    loop {
      obj = Portfolio.find_by_url_slug(slug) rescue nil
      break if obj.blank?
      i += 1
      slug = "#{base_slug}-#{i}"
    }
    self.url_slug = slug
  end

end
