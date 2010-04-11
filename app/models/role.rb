class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates_presence_of :name, :message => "can't be blank"

  def self.by_role(*opt); Role.first(:conditions => ["name=?", opt[0] || 'admin' ]) rescue nil; end
end
