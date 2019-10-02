require_relative './database_connection'

if ENV['ENVIRONMENT'] == 'test'
  DatabaseConnection.setup('filmbook_test')
else
  DatabaseConnection.setup('filmbook')
end
