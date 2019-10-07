class Showtime
  attr_reader :id, :cinema_id, :movie_id, :start_at, :auditorium, :booking_link, :cinema_name, :website, :city, :zipcode

  def initialize(id, cinema_id, movie_id, start_at, auditorium, booking_link, cinema_name, website, city, zipcode)
    @id = id
    @cinema_id = cinema_id
    @movie_id = movie_id
    @start_at = start_at
    @auditorium = auditorium
    @booking_link = booking_link
    @cinema_name = cinema_name
    @website = website
    @city = city
    @zipcode = zipcode
  end

  def self.create(showtime, cinema)
    id = showtime["id"]
    cinema_id = showtime["cinema_id"]
    movie_id = showtime["movie_id"]
    start_at = showtime["start_at"]
    auditorium = showtime["auditorium"]
    booking_link = showtime["booking_link"]
    cinema_name = cinema.name
    website = cinema.website
    city = cinema.city
    zipcode = cinema.zipcode
    Showtime.new(id, cinema_id, movie_id, start_at, auditorium, booking_link, cinema_name, website, city, zipcode)
  end
end
