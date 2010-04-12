class Notification < ActiveRecord::Base

  NOTE_TYPES = [
    'todo_added', 'todo_updated', 'todo_completed', 
    # 'todo_deleted',
    'user_added',   'portfolio_created',  'client_created', 'project_created', 
    'user_updated', 'portfolio_updated',  'client_updated', 'project_updated', 
    # 'user_deleted', 'portfolio_deleted',  'client_deleted', 'project_deleted',
    'comment', 'message'
  ]


  belongs_to  :portfolio
  belongs_to  :client
  belongs_to  :project
  belongs_to  :user

  belongs_to  :item,    :polymorphic => true
  belongs_to  :subject, :polymorphic => true


protected


end
