class Project < ActiveRecord::Base

  belongs_to  :portfolio
  belongs_to  :client

  has_many  :messages
  has_many  :todos
  has_many  :timesheets
  has_many  :comments

  # has_and_belongs_to_many :users


protected


end
