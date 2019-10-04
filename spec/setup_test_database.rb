require_relative '../lib/database_connection'

def setup_test_database
  dbUri = URI.parse("postgres://localhost:5432/filmbook_test")
  DatabaseConnection.setup(dbUri)
  DatabaseConnection.query("TRUNCATE users CASCADE;")
  DatabaseConnection.query("ALTER SEQUENCE users_id_seq RESTART WITH 1;")
  DatabaseConnection.query("TRUNCATE films CASCADE;")
  DatabaseConnection.query("ALTER SEQUENCE films_id_seq RESTART WITH 1;")
end
