require_relative './user.rb'

class Film

  def self.add(userId, filmId)
    rs = DatabaseConnection.query("INSERT INTO userFilms ('userId', 'filmId') VALUES (#{userId}, #{filmId}) RETURNING *;")
  end

  def self.findbyuserid(userId)
    rs = DatabaseConnection.query("SELECT * FROM films FULL OUTER JOIN usersFilms ON films.filmid = usersFilms.filmid WHERE userid = #{userId} ")
    rs.map do |row|
      {filmId: row[:filmId], userId: row[:userId], year: row[:year], title: row[:title], posterPath: row[:posterPath]}
    end
  end

end
