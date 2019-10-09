require_relative './user.rb'

class Film
  attr_reader :id, :film_id, :title, :poster_path, :year, :showtime_id, :backdrop_path, :overview

  def initialize(id, film_id, title, poster_path, year, showtime_id, backdrop_path, overview)
    @id = id
    @film_id = film_id
    @title = title
    @poster_path = poster_path
    @year = year
    @showtime_id = showtime_id
    @backdrop_path = backdrop_path
    @overview = overview
  end

  def ==(other)
    id == other.id &&
    film_id == other.film_id &&
    title == other.title &&
    poster_path == other.poster_path &&
    year == other.year &&
    backdrop_path == other.backdrop_path
  end

  def self.create(film_id, title, poster_path, year, showtime_id, backdrop_path, overview)
    rs = DatabaseConnection.query("INSERT INTO films (filmId, title, posterpath, year,  showtimeid, backdroppath, overview) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *;", [film_id, title, poster_path, year, showtime_id, backdrop_path, overview])
    Film.new(rs[0]["id"].to_i, rs[0]["filmid"].to_i, rs[0]["title"], rs[0]["posterpath"], rs[0]["year"].to_i, rs[0]["showtimeid"].to_i, rs[0]["backdroppath"], rs[0]["overview"])
  end

  def self.add(user_id, film_id, watched, to_watch)
    p watched == "true"
    p Film.watched?(user_id, film_id)
    p to_watch == "true"
    p Film.to_watch?(user_id, film_id)
    DatabaseConnection.query("INSERT INTO usersFilms (userId, filmId, isWatched, isToWatch) VALUES ($1, $2, $3, $4);", [user_id, film_id, watched, to_watch]) unless watched == "true" && Film.watched?(user_id, film_id) || to_watch == "true" && Film.to_watch?(user_id, film_id)
  end

  def self.remove_watched(user_id, film_id)
    DatabaseConnection.query("UPDATE usersFilms SET iswatched = false WHERE userid = $1 AND filmid = $2;", [user_id, film_id])
  end

  def self.remove_to_watch(user_id, film_id)
    DatabaseConnection.query("UPDATE usersFilms SET istowatch = false WHERE userid = $1 AND filmid = $2;", [user_id, film_id])
  end

  def self.find_by_id(film_id)
    rs = DatabaseConnection.query("SELECT * FROM films WHERE filmid = $1;", [film_id] )
    if rs.to_a.length >= 1
      Film.new(rs[0]["id"].to_i, rs[0]["filmid"].to_i, rs[0]["title"], rs[0]["posterpath"], rs[0]["year"].to_i, rs[0]["showtimeid"].to_i, rs[0]["backdroppath"], rs[0]["overview"])
    end
  end

  def self.film_exists?(film_id)
    return false unless self.find_by_id(film_id)
    return true
  end

  def self.find_by_user_id(user_id)
    rs = DatabaseConnection.query("SELECT * FROM films FULL OUTER JOIN usersFilms ON films.filmid = usersFilms.filmid WHERE userid = $1;", [user_id])
    rs.map do |row|
      Film.new(row["id"].to_i, row["filmid"].to_i, row["title"], row["posterpath"], row["year"].to_i, row["showtimeid"].to_i, row["backdroppath"], row["overview"])
    end
  end

   def self.find_to_watch(user_id)
    rs = DatabaseConnection.query("SELECT * FROM films FULL OUTER JOIN usersFilms ON films.filmid = usersFilms.filmid WHERE userid = $1 AND isToWatch = true;", [user_id])
    rs.map do |row|
      Film.new(row["id"].to_i, row["filmid"].to_i, row["title"], row["posterpath"], row["year"].to_i, row["showtimeid"].to_i, row["backdroppath"], row["overview"])
    end
  end

   def self.find_watched(user_id)
    rs = DatabaseConnection.query("SELECT * FROM films FULL OUTER JOIN usersFilms ON films.filmid = usersFilms.filmid WHERE userid = $1 AND isWatched = true;", [user_id])
    rs.map do |row|
      Film.new(row["id"].to_i, row["filmid"].to_i, row["title"], row["posterpath"], row["year"].to_i, row["showtimeid"].to_i, row["backdroppath"], row["overview"])
    end
  end

  def self.watched?(user_id, film_id)
    rs = DatabaseConnection.query("SELECT * FROM usersFilms WHERE userid = $1 AND filmid = $2 AND iswatched = true;", [user_id, film_id])
    return false if rs.to_a.empty?
    return true
  end

  def self.to_watch?(user_id, film_id)
    rs = DatabaseConnection.query("SELECT * FROM usersFilms WHERE userid = $1 AND filmid = $2 AND istowatch = true;", [user_id, film_id])
    return false if rs.to_a.empty?
    return true
  end

  def self.getRandom(user_id)
    rs = DatabaseConnection.query("SELECT filmid FROM usersfilms WHERE userid = $1  AND iswatched = true;", [user_id])
    rs.map{ |x| x.values }.flatten.sample.to_i unless rs.to_a.empty?
  end
end
