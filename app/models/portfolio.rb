class Portfolio < ActiveRecord::Base

  has_and_belongs_to_many  :users
  belongs_to  :account

  has_many  :clients
  has_many  :projects

  has_many  :messages
  has_many  :todos
  has_many  :timesheets
  has_many  :comments


  validates_presence_of     :title
  validates_length_of       :title,   :maximum => 100, :allow_nil => true


  before_create :generate_slug


  def slug; self.url_slug || self.id; end


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
