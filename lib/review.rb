class Review
  attr_reader :id, :user_id, :film_id, :review_content

  def initialize(id, user_id, film_id, review_content)
    @id = id
    @user_id = user_id
    @film_id = film_id
    @review_content = review_content
  end

  def ==(other)
    return false if other.nil?
    id == other.id &&
    user_id == other.user_id &&
    film_id == other.film_id &&
    review_content == other.review_content
   end

  def self.create(user_id, film_id, review_content)
    rs = DatabaseConnection.query("INSERT INTO reviews(userid, filmid, reviewcontent) VALUES($1, $2, $3) RETURNING *;", [user_id, film_id, review_content])
    Review.new(rs[0]["id"].to_i, rs[0]["userid"].to_i, rs[0]["filmid"].to_i, rs[0]["reviewcontent"])
  end

  def self.find_by_id(id)
    rs = DatabaseConnection.query("SELECT * FROM reviews WHERE id = $1;", [id])
    Review.new(rs[0]["id"].to_i, rs[0]["userid"].to_i, rs[0]["filmid"].to_i, rs[0]["reviewcontent"]) if rs.to_a.length >= 1
  end

  def self.find_by_film_id(film_id)
    rs = DatabaseConnection.query("SELECT * FROM reviews WHERE filmid = $1;", [film_id])
    if rs.to_a.length >= 0
      rs.map { |review|
        Review.new(review["id"].to_i, review["userid"].to_i, review["filmid"].to_i, review["reviewcontent"])
      }
    end
  end

  def self.find_by_user_id(user_id)
    rs = DatabaseConnection.query("SELECT * FROM reviews WHERE userid = $1;", [user_id])
    if rs.to_a.length >= 0
      rs.map { |review|
        Review.new(review["id"].to_i, review["userid"].to_i, review["filmid"].to_i, review["reviewcontent"])
      }
    end
  end
end
