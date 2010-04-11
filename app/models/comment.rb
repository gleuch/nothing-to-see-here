class Comment < ActiveRecord::Base

  belongs_to  :portfolio
  belongs_to  :client
  belongs_to  :project
  belongs_to  :user

  belongs_to  :item
  belongs_to  :message,   :through => :item, :conditions => "item_kind='Message'"
  belongs_to  :todo,      :through => :item, :conditions => "item_kind='Todo'"
  belongs_to  :timesheet, :through => :item, :conditions => "item_kind='Timesheet'"


protected


end
