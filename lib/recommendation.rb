class Recommendation
  attr_reader :film_id, :title, :poster_path

  def initialize(film_id, title, poster_path)
    @film_id = film_id
    @title = title
    @poster_path = poster_path
  end

end
