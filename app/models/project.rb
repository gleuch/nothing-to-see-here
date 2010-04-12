class Project < ActiveRecord::Base

  has_and_belongs_to_many :users
  belongs_to  :portfolio
  belongs_to  :client

  has_many  :messages
  has_many  :todos
  has_many  :timesheets
  has_many  :comments
  has_many  :notifications, :order => 'created_at DESC, id DESC', :conditions => 'NOT(note_type LIKE "%_updated") AND NOT(note_type LIKE "%_deleted")'

  # has_and_belongs_to_many :users


  after_create  { |portfolio| portfolio.create_notification(:note_type => 'project_created') }
  after_update  { |portfolio| portfolio.create_notification(:note_type => 'project_updated') }
  after_destroy { |portfolio| portfolio.create_notification(:note_type => 'project_deleted') }


  def slug
    STDERR.puts "[DEPRECIATED] Should not be using Project.slug. Use Project.id instead."
    self.id
  end


  def add_user(user)
    self.users << user
    create_notification(:note_type => 'user_added', :subject_type => user.class.to_s, :subject_id => user.id)
  end

  def remove_user(user)
    self.users.delete(user)
    create_notification(:note_type => 'user_removed', :subject_type => user.class.to_s, :subject_id => user.id)
  end

  def create_notification(*opts)
    options = {:portfolio_id => self.portfolio_id, :client_id => self.client_id, :project_id => self.id, :item_type => self.class.to_s, :item_id => self.id}.merge( opts.extract_options! )
    options[:user_id] = User.current_user.id
    Notification.create(options)
  end


protected


end
