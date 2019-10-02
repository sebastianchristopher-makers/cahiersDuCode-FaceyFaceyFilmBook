require_relative '../lib/database_connection'

def setup_test_database
  connection = DatabaseConnection.setup("filmbook_test")
  connection.query("TRUNCATE users;")
  connection.query("ALTER SEQUENCE users_id_seq RESTART WITH 1;")
end
