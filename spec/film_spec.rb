require 'film'
require 'user'

describe Film do

  before(:each) do
    User.create('chris@example.com',  'Password1234')
  end

  it 'creates a new film' do
    film = Film.create(13446, 'Withnail & I', '/lXD5UR2dvXJF54AIBt8G2kDvYGk.jpg', 1987, 1, '/backdroppath')
    expect(film).to be_a(Film)
  end

  context 'after it is created' do
    let(:film) { Film.create(13446, 'Withnail & I', '/lXD5UR2dvXJF54AIBt8G2kDvYGk.jpg', 1987, 1, '/backdroppath') }

    it 'has an id' do
      expect(film.id).to eq(1)
    end

    it 'has a film_id' do
      expect(film.film_id).to eq(13446)
    end

    it 'has a title' do
      expect(film.title).to eq('Withnail & I')
    end

    it 'has a poster_path' do
      expect(film.poster_path).to eq('/lXD5UR2dvXJF54AIBt8G2kDvYGk.jpg')
    end

    it 'has a year' do
      expect(film.year).to eq(1987)
    end

    it 'has a showtime_id' do
      expect(film.showtime_id).to eq(1)
    end

    it 'has a backdrop path' do
      expect(film.backdrop_path).to eq('/backdroppath')
    end
  end

  it 'adds a film to films' do
    film = Film.create(13446, 'Withnail & I', '/lXD5UR2dvXJF54AIBt8G2kDvYGk.jpg', 1987, 1, '/backdroppath')
    Film.add(1, film.film_id, false, false)
    rs = DatabaseConnection.query('SELECT * FROM usersFilms;')
    expect(rs[0]).to eq({'id'=>"1", 'userid'=>"1", 'filmid'=>'13446', 'istowatch' => 'f', 'iswatched' => 'f'})
  end

  it 'can find all films added by a user' do
    User.create('otheruser@example.com',  'Password1234')

    film = Film.create(13446, 'Withnail & I', '/lXD5UR2dvXJF54AIBt8G2kDvYGk.jpg', 1987, 1, '/backdroppath')
    film_2 = Film.create(343, 'Harold and Maude', '/xqay68babjK46U9WBFD2TmtnGcx.jpg', 1971, 2, '/backdroppath')
    film_3 = Film.create(42497, 'Pink Narcissus', '/kaZiiGE6820KyFF9XkzPB9Rx9qn.jpg', 1971, 3, '/backdroppath')

    Film.add(1, film.film_id, false, false)
    Film.add(2, film_2.film_id, false, false)
    Film.add(1, film_3.film_id, false, false)
    expect(Film.find_by_user_id(1)).to contain_exactly(film, film_3)
  end

  it 'can find a film by film id' do
    film = Film.create(13446, 'Withnail & I', '/lXD5UR2dvXJF54AIBt8G2kDvYGk.jpg', 1987, 1, '/backdroppath')
    expect(Film.find_by_id(13446)).to eq(film)
  end

  it 'checks whether a film exists' do
    film = Film.create(13446, 'Withnail & I', '/lXD5UR2dvXJF54AIBt8G2kDvYGk.jpg', 1987, 1, '/backdroppath')
    expect(Film.film_exists?(13446)).to be true
  end

  it 'checks whether a film does not exist' do
    expect(Film.film_exists?(13446)).to be false
  end

  context 'when finding films' do
    before(:each) do
      Film.create(1, 'Foo', '/posterpath', 1922, 1, 'backdroppath')
      Film.create(2, 'Bar', '/posterpath', 1922, 1, 'backdroppath')
      Film.create(3, 'Lol', '/posterpath', 1922, 1, 'backdroppath')
      Film.create(4, 'Cats', '/posterpath', 1922, 1, 'backdroppath')
    end
    
    let(:film_1) { Film.find_by_id(1) }
    let(:film_2) { Film.find_by_id(2) }
    let(:film_3) {  Film.find_by_id(3) }
    let(:film_4) {  Film.find_by_id(4) }

    it 'can find all films a user has added' do
      User.create('matz@example.com',  'Password1234')
      Film.add(1, 1, false, false)
      Film.add(2, 2, false, false)
      Film.add(1, 3, false, false)
      Film.add(1, 4, false, false)
      expect(Film.find_by_user_id(1)).to contain_exactly(film_1, film_3, film_4)
    end

    it 'can find all films in a user\'s to watch list' do
      Film.add(1, 1, false, true)
      Film.add(1, 2, false, false)
      Film.add(1, 3, false, true)
      Film.add(1, 4, false, true)
      expect(Film.find_to_watch(1)).to contain_exactly(film_1, film_3, film_4)
    end

    it 'can find all films in a user\'s watched list' do
      Film.add(1, 1, true, false)
      Film.add(1, 2, false, false)
      Film.add(1, 3, true, false)
      Film.add(1, 4, true, false)
      expect(Film.find_watched(1)).to contain_exactly(film_1, film_3, film_4)
    end
  end

  after(:each) do
    DatabaseConnection.query('TRUNCATE usersFilms RESTART IDENTITY CASCADE;')
    DatabaseConnection.query('TRUNCATE users RESTART IDENTITY CASCADE;')
    DatabaseConnection.query('TRUNCATE films RESTART IDENTITY CASCADE;')
  end

end
