require_relative './user.rb'

class Film
  attr_reader :id, :film_id, :title, :poster_path, :year

  def initialize(id, film_id, title, poster_path, year)
    @id = id
    @film_id = film_id
    @title = title
    @poster_path = poster_path
    @year = year
  end

  def ==(other)
   id == other.id &&
    film_id == other.film_id &&
    title == other.title &&
    poster_path == other.poster_path &&
    year == other.year
  end

  def self.create(film_id, title, poster_path, year)
    rs = DatabaseConnection.query("INSERT INTO films (filmId, title, posterpath, year) VALUES (#{film_id}, '#{title}', '#{poster_path}', #{year}) RETURNING *;")
    p rs[0]
    Film.new(rs[0]["id"].to_i, rs[0]["filmid"].to_i, rs[0]["title"], rs[0]["posterpath"], rs[0]["year"].to_i)
  end

  def self.add(user_id, film_id)
    DatabaseConnection.query("INSERT INTO usersFilms (userId, filmId) VALUES (#{user_id}, #{film_id});")
  end

  def self.find_by_user_id(userId)
    rs = DatabaseConnection.query("SELECT * FROM films FULL OUTER JOIN usersFilms ON films.filmid = usersFilms.filmid WHERE userid = #{userId} ")
    rs.map do |row|
      Film.new(row["id"].to_i, row["filmid"].to_i, row["title"], row["posterpath"], row["year"].to_i)
    end
  end

end
