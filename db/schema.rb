# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100402015249) do

  create_table "accounts", :force => true do |t|
    t.string  "url_slug"
    t.string  "company"
    t.string  "email"
    t.integer "option_portfolios_count", :default => 1
    t.boolean "option_timesheets",       :default => true
    t.boolean "option_messages",         :default => true
    t.boolean "option_comments",         :default => true
    t.boolean "option_todos",            :default => true
    t.integer "owner_id"
    t.string  "status",                  :default => "active"
    t.boolean "active",                  :default => true
  end

  create_table "accounts_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", :force => true do |t|
    t.integer  "portfolio_id"
    t.string   "url_slug"
    t.string   "name"
    t.string   "site"
    t.integer  "option_projects_count", :default => 25
    t.string   "status",                :default => "active"
    t.boolean  "active",                :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "portfolio_id"
    t.integer  "project_id"
    t.integer  "client_id"
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "item_kind"
    t.text     "comment"
    t.string   "status",       :default => "active"
    t.boolean  "active",       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "portfolio_id"
    t.integer  "client_id"
    t.integer  "item_id"
    t.string   "item_kind"
    t.text     "message"
    t.integer  "category_id"
    t.integer  "creator_id"
    t.string   "status",       :default => "active"
    t.boolean  "active",       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messsage_notifications_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "portfolios", :force => true do |t|
    t.integer  "account_id"
    t.string   "url_slug"
    t.string   "title"
    t.text     "description"
    t.integer  "option_clients_count", :default => 3
    t.string   "status",               :default => "active"
    t.boolean  "active",               :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "portfolios_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "portfolio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.integer  "portfolio_id"
    t.integer  "client_id"
    t.string   "name"
    t.text     "description"
    t.string   "cached_tags"
    t.string   "status",       :default => "active"
    t.boolean  "active",       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "active",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timesheets", :force => true do |t|
    t.integer  "portfolio_id"
    t.integer  "client_id"
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "item_kind"
    t.string   "message"
    t.float    "time_spent"
    t.date     "worked_at"
    t.string   "status",       :default => "active"
    t.boolean  "active",       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todo_notifications_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "todo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todos", :force => true do |t|
    t.integer  "portfolio_id"
    t.integer  "client_id"
    t.integer  "assigned_id"
    t.integer  "creator_id"
    t.integer  "item_id"
    t.string   "item_kind"
    t.string   "title"
    t.text     "description"
    t.string   "due_at"
    t.string   "status",       :default => "active"
    t.boolean  "active",       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "salt",                      :limit => 40
    t.string   "crypted_password",          :limit => 40
    t.string   "remember_token"
    t.string   "activation_code"
    t.string   "password_reset_code"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "description"
    t.string   "website"
    t.string   "gender"
    t.string   "photo_file_name"
    t.string   "photo_file_size"
    t.string   "photo_content_type"
    t.string   "twitter_username"
    t.string   "cached_roles"
    t.string   "cached_badges"
    t.string   "cached_notifications"
    t.string   "status",                                  :default => "active"
    t.datetime "photo_updated_at"
    t.datetime "activated_at"
    t.datetime "deleted_at"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
