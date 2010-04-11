class Timesheet < ActiveRecord::Base

  belongs_to  :portfolio
  belongs_to  :client
  belongs_to  :project
  belongs_to  :user



end
