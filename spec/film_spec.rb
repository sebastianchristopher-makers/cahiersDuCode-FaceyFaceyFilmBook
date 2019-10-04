require 'film'
require 'user'

describe Film do

  before(:each) do
    User.create("chris@example.com",  "Password1234")
  end

  it "creates a new film" do
    film = Film.create(13446, 'Withnail & I', "/lXD5UR2dvXJF54AIBt8G2kDvYGk.jpg", 1987)
    expect(film).to be_a(Film)
  end

  context "after it is created" do
    let(:film) { Film.create(13446, 'Withnail & I', "/lXD5UR2dvXJF54AIBt8G2kDvYGk.jpg", 1987) }

    it "has an id" do
      expect(film.id).to eq(1)
    end

    it "has a film_id" do
      expect(film.film_id).to eq(13446)
    end

    it "has a title" do
      expect(film.title).to eq('Withnail & I')
    end

    it "has a poster_path" do
      expect(film.poster_path).to eq("/lXD5UR2dvXJF54AIBt8G2kDvYGk.jpg")
    end

    it "has a year" do
      expect(film.year).to eq(1987)
    end
  end

  it 'adds a film to films' do
    film = Film.create(13446, 'Withnail & I', "/lXD5UR2dvXJF54AIBt8G2kDvYGk.jpg", 1987)
    Film.add(1, film.film_id)
    rs = DatabaseConnection.query("SELECT * FROM usersFilms;")
    expect(rs[0]).to eq({"id"=>"1", "userid"=>"1", "filmid"=>"13446"})
  end

  it "can find all films added by a user" do
    User.create("otheruser@example.com",  "Password1234")

    film = Film.create(13446, 'Withnail & I', "/lXD5UR2dvXJF54AIBt8G2kDvYGk.jpg", 1987)
    film_2 = Film.create(343, 'Harold and Maude', "/xqay68babjK46U9WBFD2TmtnGcx.jpg", 1971)
    film_3 = Film.create(42497, 'Pink Narcissus', "/kaZiiGE6820KyFF9XkzPB9Rx9qn.jpg", 1971)

    Film.add(1, film.film_id)
    Film.add(2, film.film_id)
    Film.add(1, film.film_id)
    expect(Film.find_by_user_id(1)).to contain_exactly(film, film_3)
  end

  after(:each) do
    DatabaseConnection.query("TRUNCATE usersFilms RESTART IDENTITY CASCADE;")
    DatabaseConnection.query("TRUNCATE users RESTART IDENTITY CASCADE;")
    DatabaseConnection.query("TRUNCATE films RESTART IDENTITY CASCADE;")
  end

end
