class Cinema

  attr_reader :id, :cinema_id, :name, :website, :city, :zipcode

  def initialize(id, cinema_id, name, website, city, zipcode)
    @id = id
    @cinema_id = cinema_id
    @name = name
    @website = website
    @city = city
    @zipcode = zipcode
  end

  def ==(other)
   id == other.id &&
    cinema_id == other.cinema_id &&
    name == other.name &&
    website == other.website &&
    city == other.city &&
    zipcode == other.zipcode
  end

  def self.create(cinema_id, name, website, city, zipcode)
    rs = DatabaseConnection.query("INSERT INTO cinemas(cinemaid, name, website, city, zipcode) VALUES ($1, $2, $3, $4, $5) RETURNING *;", [cinema_id, name, website, city, zipcode])
    Cinema.new(rs[0]["id"].to_i, rs[0]["cinemaid"].to_i, rs[0]["name"], rs[0]["website"], rs[0]["city"], rs[0]["zipcode"])
  end

  def self.find_by_cinema_id(cinema_id)
    rs = DatabaseConnection.query("SELECT * FROM cinemas WHERE cinemaid = $1;", [cinema_id])
    if rs.to_a.length >= 1
      Cinema.new(rs[0]["id"].to_i, rs[0]["cinemaid"].to_i, rs[0]["name"], rs[0]["website"], rs[0]["city"], rs[0]["zipcode"])
    end
  end

  def self.cinema_exists?(cinema_id)
    return false unless self.find_by_cinema_id(cinema_id)
    return true
  end

end
