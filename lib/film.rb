require_relative './user.rb'

class Film

  def self.add(userId, filmId)
    rs = DatabaseConnection.query("INSERT INTO userFilms ('userId', 'filmId') VALUES (#{userId}, #{filmId}) RETURNING *;")
  end

  def self.findbyuserid(userId)
    rs = DatabaseConnection.query("SELECT * FROM films FULL OUTER JOIN usersFilms ON films.filmid = usersFilms.filmid WHERE userid = #{userId} ")
    rs.map do |row|
      Film.new(row["id"].to_i, row["filmid"].to_i, row["title"], row["posterpath"], row["year"].to_i)    
    end
  end

end
