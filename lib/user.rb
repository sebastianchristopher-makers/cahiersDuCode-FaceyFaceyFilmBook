require 'bcrypt'

class User

attr_reader :email, :id, :films

  def initialize(id, email)
    @email = email
    @id = id
    @films = []
  end


  def ==(other)
    return false if other.nil?
    id == other.id &&
    email == other.email &&
    films == other.films
   end

  def self.create(email, password)
    hashed_password = BCrypt::Password.create(password)
    rs = DatabaseConnection.query("INSERT into users (email, password) VALUES('#{email}', '#{hashed_password}') RETURNING *;")
    return User.new(rs[0]["id"].to_i, email)
  end

  def self.user_exists?(email)
    rs = DatabaseConnection.query("SELECT * FROM users WHERE email = '#{email}';")
    if rs.to_a.length >= 1
      true
    else
      false
    end
  end

  def self.authenticate(email, password)
    rs = DatabaseConnection.query("SELECT * FROM users WHERE email = '#{email}';")
    BCrypt::Password.new(rs[0]["password"]) == password
    if BCrypt::Password.new(rs[0]["password"]) == password
      return User.new(rs[0]["id"].to_i, email)
    else

    end
  end

  def self.find_by_id(userid)
    rs = DatabaseConnection.query("SELECT * FROM users WHERE id = '#{userid}';")
    return User.new(rs[0]["id"].to_i, rs[0]["email"])
  end
end
