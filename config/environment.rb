# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'digest/sha1'

Rails::Initializer.run do |config|
  config.gem "haml"
  config.gem "rubyist-aasm", :lib => "aasm", :version => "~> 2.0.5"
  config.gem "mislav-will_paginate", :lib => "will_paginate", :version => "~>2.3.6"
  config.gem "ambethia-recaptcha", :lib => "recaptcha/rails", :source => "http://gems.github.com"

  config.gem "rspec", :lib => false, :version => ">= 1.2.0" 
  config.gem "rspec-rails", :lib => false, :version => ">= 1.2.0"   
  config.gem "aslakhellesoy-cucumber", :lib => false, :source => 'http://gems.github.com'
  config.gem "thoughtbot-factory_girl", :lib => false, :source => "http://gems.github.com"
  config.gem "jscruggs-metric_fu", :lib => false, :source => 'http://gems.github.com'
  config.gem 'timcharper-spork', :lib => false, :source => 'http://gems.github.com'

  # Skip frameworks you're not going to use. To use Rails without a database, you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer


  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :en
end


Haml::Template::options[:ugly] = true
ActiveRecord::Base.include_root_in_json = true