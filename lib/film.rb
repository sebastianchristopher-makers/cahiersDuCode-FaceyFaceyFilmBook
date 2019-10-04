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

  def self.create(film_id, title, poster_path, year)
    rs = DatabaseConnection.query("INSERT INTO films (filmId, title, posterpath, year) VALUES (#{film_id}, '#{title}', '#{poster_path}', #{year}) RETURNING *;")
    p rs[0]
    Film.new(rs[0]["id"].to_i, rs[0]["filmid"].to_i, rs[0]["title"], rs[0]["posterpath"], rs[0]["year"].to_i)
  end

  def self.add(user_id, film_id)
    DatabaseConnection.query("INSERT INTO usersFilms (userId, filmId) VALUES (#{user_id}, #{film_id});")
  end

  def self.find_by_user_id(user_id)
    rs = DatabaseConnection.query("SELECT * FROM usersFilms WHERE userId=#{user_id}")
    rs.map { |row|
      row[:filmId]
    }
  end

end
