class User

attr_reader :email, :id, :films

  def initialize(id, email)
    @email = email
    @id = id
    @films = []
  end

  def self.create(email, password)

  end

end
