def in_memory_database?
  return false unless Rails.env == "test"

  db_config = Rails.configuration.database_configuration['test']

  db_config && db_config['adapter'] == 'sqlite3' && db_config['database'] == ':memory:'
end

if in_memory_database?
  puts "creating sqlite in memory database"
  load "#{Rails.root}/db/schema.rb"
end
