require_relative './user.rb'

class Film

  def self.add(userId, filmId)
    rs = DatabaseConnection.query("INSERT INTO userFilms ('userId', 'filmId') VALUES (#{userId}, #{filmId}) RETURNING *;")
  end

  def self.all(user_id)
    rs = DatabaseConnection.query("SELECT * FROM usersFilms WHERE userId=#{user_id}")
    rs.map do |row|
      row[:filmId]
    end
  end

end
