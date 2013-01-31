pending_migrations = ActiveRecord::Migrator.new(:up, 'db/migrate').pending_migrations
if pending_migrations.any?
  #ENV["PENDING_MIGRATIONS"] = "#{true}"
end


ActiveRecord::Base.logger = Logger.new(STDOUT)

