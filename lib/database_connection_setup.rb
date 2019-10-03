require_relative './database_connection'

if ENV['ENVIRONMENT'] == 'test'
  dbUri = URI.parse("postgres://localhost:5432/filmbook_test")
  DatabaseConnection.setup(dbUri)
else
  dbUri = URI.parse("postgres://localhost:5432/filmbook_test")
  DatabaseConnection.setup(dbUri)
end
