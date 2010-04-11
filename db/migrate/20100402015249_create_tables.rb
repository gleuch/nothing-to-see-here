class CreateTables < ActiveRecord::Migration
  def self.up

    # Account table
    create_table :accounts do |t|
      t.string      :url_slug
      t.string      :company
      t.string      :email
      t.integer     :option_portfolios_count, :default => 1
      t.boolean     :option_timesheets,       :default => true
      t.boolean     :option_messages,         :default => true
      t.boolean     :option_comments,         :default => true
      t.boolean     :option_todos,            :default => true
      t.integer     :owner_id
      t.string      :status,                  :default => 'active'
      t.boolean     :active,                  :default => true
    end

    # User<-->Account association table
    create_table :accounts_users, :id => false do |t|
      t.integer     :user_id
      t.integer     :account_id
      t.timestamps
    end

    # Client table
    create_table :clients do |t|
      t.integer     :portfolio_id
      t.string      :url_slug
      t.string      :name
      t.string      :site
      t.integer     :option_projects_count,   :default => 25
      t.string      :status,                  :default => 'active'
      t.boolean     :active,                  :default => true
      t.timestamps
    end

    # User<-->Client association table
    create_table :clients_users, :id => false do |t|
      t.integer     :user_id
      t.integer     :client_id
      t.timestamps
    end

    # Comment table
    create_table :comments do |t|
      t.integer     :portfolio_id
      t.integer     :project_id
      t.integer     :client_id
      t.integer     :user_id
      t.integer     :item_id
      t.string      :item_kind
      t.text        :comment
      t.string      :status,          :default => 'active'
      t.boolean     :active,          :default => true
      t.timestamps
    end

    # Message table
    create_table :messages do |t|
      t.integer     :portfolio_id
      t.integer     :client_id
      t.integer     :item_id
      t.string      :item_kind
      t.text        :message
      t.integer     :category_id
      t.integer     :creator_id
      t.string      :status,          :default => 'active'
      t.boolean     :active,          :default => true
      t.timestamps
    end

    # User<-->Message Notification association table
    create_table  :messsage_notifications_users, :id => false do |t|
      t.integer     :user_id
      t.integer     :message_id
      t.timestamps
    end

    # Portfolio table
    create_table :portfolios do |t|
      t.integer     :account_id
      t.string      :url_slug
      t.string      :title
      t.text        :description
      t.integer     :option_clients_count,    :default => 3
      t.string      :status,                  :default => 'active'
      t.boolean     :active,                  :default => true
      t.timestamps
    end

    # User<-->Portfolios association table
    create_table :portfolios_users, :id => false do |t|
      t.integer     :user_id
      t.integer     :portfolio_id
      t.timestamps
    end

    # Project table
    create_table :projects do |t|
      t.integer     :portfolio_id
      t.integer     :client_id
      # t.string      :url_slug
      t.string      :name
      t.text        :description
      t.string      :cached_tags
      t.string      :status,            :default => 'active'
      t.boolean     :active,            :default => true
      t.timestamps
    end

    # Roles table
    create_table :roles do |t|
      t.string      :name
      t.string      :description
      t.boolean     :active,            :default => true
      t.timestamps
    end

    # User<-->Roles association table
    create_table :roles_users, :id => false do |t|
      t.integer     :user_id
      t.integer     :role_id
      t.timestamps
    end

    # Timesheet table
    create_table :timesheets do |t|
      t.integer     :portfolio_id
      t.integer     :client_id
      t.integer     :user_id
      t.integer     :item_id
      t.string      :item_kind
      t.string      :message
      t.float       :time_spent
      t.date        :worked_at
      t.string      :status,        :default => 'active'
      t.boolean     :active,        :default => true
      t.timestamps
    end

    # Todo table
    create_table :todos do |t|
      t.integer     :portfolio_id
      t.integer     :client_id
      t.integer     :assigned_id
      t.integer     :creator_id
      t.integer     :item_id
      t.string      :item_kind
      t.string      :title
      t.text        :description
      t.string      :due_at
      t.string      :status,          :default => 'active'
      t.boolean     :active,          :default => true
      t.timestamps
    end

    # User<-->Todo Notification association table
    create_table  :todo_notifications_users, :id => false do |t|
      t.integer     :user_id
      t.integer     :todo_id
      t.timestamps
    end

    # Users table
    create_table :users do |t|
      t.string      :login
      t.string      :email
      t.string      :salt,                        :limit => 40
      t.string      :crypted_password,            :limit => 40
      t.string      :remember_token
      t.string      :activation_code
      t.string      :password_reset_code
      t.string      :first_name
      t.string      :last_name
      t.text        :description
      t.string      :website
      t.string      :gender
      t.string      :photo_file_name
      t.string      :photo_file_size
      t.string      :photo_content_type
      t.string      :twitter_username
      t.string      :cached_roles
      t.string      :cached_badges
      t.string      :cached_notifications
      t.string      :status,                      :default => 'active'
      t.datetime    :photo_updated_at
      t.datetime    :activated_at
      t.datetime    :deleted_at
      t.datetime    :remember_token_expires_at
      t.timestamps
    end

    Role.create(:name => 'admin', :description => 'Sysop Administrator')
    Role.create(:name => 'owner', :description => 'Portfolio Owner')
    Role.create(:name => 'staff', :description => 'Portfolio Staff Member')
    Role.create(:name => 'client', :description => 'Client')

    add_index :users, :login, :unique => true

  end

  def self.down
    drop_table :accounts
    drop_table :accounts_users
    drop_table :clients
    drop_table :clients_users
    drop_table :comments
    drop_table :messages
    drop_table :messsage_notifications_users
    drop_table :portfolios
    drop_table :portfolios_users
    drop_table :projects
    drop_table :roles
    drop_table :roles_users
    drop_table :timesheets
    drop_table :todos
    drop_table :todo_notifications_users
    drop_table :users
  end
end
