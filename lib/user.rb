require 'bcrypt'

class User

attr_reader :email, :id, :films, :favourite_film

  def initialize(id, email, favourite_film = nil)
    @email = email
    @id = id
    @films = []
    @favourite_film = favourite_film
  end


  def ==(other)
    return false if other.nil?
    id == other.id &&
    email == other.email &&
    films == other.films &&
    favourite_film == other.favourite_film
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
    return User.new(rs[0]["id"].to_i, rs[0]["email"], rs[0]["favouritefilm"])
  end

  def self.add_favourite(film_id, user_id)
    DatabaseConnection.query("UPDATE users SET favouritefilm = $1 WHERE id = $2;", [film_id, user_id])
  end
end
