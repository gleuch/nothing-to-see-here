class Comment < ActiveRecord::Base

  belongs_to  :portfolio
  belongs_to  :client
  belongs_to  :project
  belongs_to  :user

  belongs_to  :item
  belongs_to  :message,   :through => :item, :conditions => "item_type='Message'"
  belongs_to  :todo,      :through => :item, :conditions => "item_type='Todo'"
  belongs_to  :timesheet, :through => :item, :conditions => "item_type='Timesheet'"


protected


end
