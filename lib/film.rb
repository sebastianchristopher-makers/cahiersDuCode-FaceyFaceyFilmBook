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
    rs = DatabaseConnection.query("INSERT INTO films (filmId, title, posterpath, year) VALUES ($1, $2, $3, $4) RETURNING *;", [film_id, title, poster_path, year])
    Film.new(rs[0]["id"].to_i, rs[0]["filmid"].to_i, rs[0]["title"], rs[0]["posterpath"], rs[0]["year"].to_i)
  end

  def self.add(user_id, film_id)
    DatabaseConnection.query("INSERT INTO usersFilms (userId, filmId) VALUES ($1, $2);", [user_id, film_id])
  end

  def self.find_by_user_id(user_id)
    rs = DatabaseConnection.query("SELECT * FROM films FULL OUTER JOIN usersFilms ON films.filmid = usersFilms.filmid WHERE userid = $1;", [user_id])
    rs.map do |row|
      Film.new(row["id"].to_i, row["filmid"].to_i, row["title"], row["posterpath"], row["year"].to_i)
    end
  end

end
