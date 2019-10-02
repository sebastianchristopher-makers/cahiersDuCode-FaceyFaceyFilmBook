#in setup_test_database.rb
require 'pg'
​
def setup_test_database
​  p "Setting up test database..."
​  # Connect to the test database
  connection = PG.connect(dbname: 'filmbook_test')
  # Clear the users table
  connection.exec("TRUNCATE users;")
​end
