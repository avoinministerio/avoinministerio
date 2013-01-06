namespace :db do
  namespace :schema do
    # desc 'Dump additional database schema'
    task :dump => [:environment, :load_config] do
      filename = "#{Rails.root}/db/schema.rb"
      File.open(filename, 'w:utf-8') do |file|
        ActiveRecord::Base.establish_connection("avoin_ministerio_#{Rails.env}")
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end

  namespace :test do
    # desc 'Purge and load avoinministerio_testjs schema'
    task :load_schema do
      # like db:test:purge
      database_configs = ActiveRecord::Base.configurations
      # like db:test:load_schema
      ActiveRecord::Base.establish_connection('testjs')
      ActiveRecord::Schema.verbose = false
      load("#{Rails.root}/db/schema.rb")
    end
  end
end
