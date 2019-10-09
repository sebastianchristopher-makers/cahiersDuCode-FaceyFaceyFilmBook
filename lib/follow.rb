class Follower
    attr_reader :id, :user_id, :follower_id

    def initialize(id, user_id, follower_id)
        @id = id
        @user_id = user_id
        @follower_id = follower_id
    end

    def ==(other)
        return false if other.nil?
        id == other.id &&
        user_id == other.user_id &&
        follower_id = other.follower_id
    end

    def self.add(user_id, follower_id)
        rs = DatabaseConnection.query("INSERT INTO followers (userID, followerID) VALUES (#{user_id}, #{follower_id}) RETURNING *;")
        return Follower.new(rs[0]["id"].to_i, rs[0]["user_id"].to_i, rs[0]["follower_id"].to_i)
    end

    def self.find_by_user_id(user_id)
        rs = DatabaseConnection.query("SELECT * FROM followers WHERE userID = #{user_id}")
        if rs.to_a.length > 0
          rs.map do |follow|
            Follower.new(follow["id"].to_i, follow["user_id"].to_i, follow["follower_id"].to_i)
          end
        end
    end

    def self.get_followers(user_id) # number of followers a user has
      rs = DatabaseConnection.query("SELECT COUNT(followerid) AS followers FROM followers WHERE followerid = #{user_id};")
      return rs[0]["followers"].to_i
    end

    def self.get_following(user_id) # number of people a user is following
      rs = DatabaseConnection.query("SELECT COUNT(userid) AS following FROM followers WHERE userid = #{user_id};")
      return rs[0]["following"].to_i
    end

end
