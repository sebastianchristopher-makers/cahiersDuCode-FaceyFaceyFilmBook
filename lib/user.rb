class User

attr_reader :email, :id, :films

  def initialize(id, email)
    @email = email
    @id = id
    @films = []
  end

  def self.create(email, password)
    rs = DatabaseConnection.query("INSERT into users (email, password) VALUES( '#{email}', '#{password}') RETURNING *;")
    return User.new(rs[0]["id"].to_i, email)
  end

end
