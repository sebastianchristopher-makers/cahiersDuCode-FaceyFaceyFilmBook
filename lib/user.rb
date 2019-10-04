require 'bcrypt'

class User

attr_reader :email, :id, :films

  def initialize(id, email)
    @email = email
    @id = id
    @films = []
  end

  def self.create(email, password)
    hashed_password = BCrypt::Password.create(password)
    rs = DatabaseConnection.query("INSERT into users (email, password) VALUES('#{email}', '#{hashed_password}') RETURNING *;")
    return User.new(rs[0]["id"].to_i, email)
  end

  def self.authenticate(email, password)
    rs = DatabaseConnection.query("SELECT * FROM users WHERE email = '#{email}';")
    BCrypt::Password.new(rs[0]["password"]) == password
    if BCrypt::Password.new(rs[0]["password"]) == password
      return User.new(rs[0]["id"].to_i, email)
    else
      "Try Again"
    end
  end
end
