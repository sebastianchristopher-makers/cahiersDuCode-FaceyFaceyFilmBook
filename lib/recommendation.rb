class Recommendation
  attr_reader :film_id, :title, :poster_path, :year, :backdrop_path, :overview

  def initialize(film_id, title, poster_path, year, backdrop_path, overview)
    @film_id = film_id
    @title = title
    @poster_path = poster_path
    @year = year
    @backdrop_path = backdrop_path
    @overview = overview
  end

  def self.create(result)
    film_id = result['id']
    title = result['original_title']
    poster_path = result['poster_path']
    year = result['year']
    backdrop_path = result['backdrop_path']
    overview = result['overview']
    Recommendation.new(film_id, title, poster_path, year, backdrop_path, overview)
  end
end
