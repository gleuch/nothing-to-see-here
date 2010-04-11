namespace :db do
  namespace :migrate do
    desc "Rollback the database schema to the previous version"
    task :rollback => :environment do
      ActiveRecord::Migrator.rollback("db/migrate/", 1)
    end
  end
end