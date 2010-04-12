class Timesheet < ActiveRecord::Base

  belongs_to  :portfolio
  belongs_to  :client
  belongs_to  :project
  belongs_to  :user
  belongs_to  :item,      :polymorphic => true

  validates_presence_of   :time_spent
  validates_presence_of   :worked_at


protected

  # Custom validations
  def validate
    # If this is attached to an item, then it should not need a message (can be inferred to from its association). Otherwise, a message should be required.
    errors.add_to_base "Please enter a message." if item.blank? && message.blank?

    # Ensure that this is not a duplicate.
    conditions = ["time_spent=#{self.time_spent} AND worked_at='#{self.worked_at.to_s(:db)}'"]
    conditions << (self.message.blank? ? "message IS NULL" : "message='#{self.message.gsub(/\'/, "\'")}'")
    conditions << (self.project.blank? ? "project_id IS NULL" : "project_id=#{self.project.id}")
    conditions << (self.client.blank? ? "client_id IS NULL" : "client_id=#{self.client.id}")
    conditions << (self.portfolio.blank? ? "portfolio_id IS NULL" : "portfolio_id=#{self.portfolio.id}")
    conditions << (self.item.blank? ? "item_id IS NULL AND item_type IS NULL" : "item_id=#{self.item.id} AND item_type='#{self.item.class.to_s}'")
    count = Timesheet.count(:conditions => conditions.join(' AND '))
    errors.add_to_base "Please ensure this is not a duplicate" if count > 0
  end

end
