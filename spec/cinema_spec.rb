require 'cinema'

describe Cinema do
  it 'can create a cinema' do
    cinema = Cinema.create(30698, 'Prince Charles Cinema', 'http://www.princecharlescinema.com/', 'London', 'WC2H 7BY')
    expect(cinema).to be_a(Cinema)
  end
  context 'after it is created' do
    let(:cinema) { Cinema.create(30698, 'Prince Charles Cinema', 'http://www.princecharlescinema.com/', 'London', 'WC2H 7BY') }

    it 'has an id' do
      expect(cinema.id).to eq(1)
    end

    it 'has a cinema id' do
      expect(cinema.cinema_id).to eq(30698)
    end

    it 'has a name' do
      expect(cinema.name).to eq('Prince Charles Cinema')
    end

    it 'has a website' do
      expect(cinema.website).to eq('http://www.princecharlescinema.com/')
    end

    it 'has a city' do
      expect(cinema.city).to eq('London')
    end

    it 'has a zipcode' do
      expect(cinema.zipcode).to eq('WC2H 7BY')
    end
  end

  it 'can find a cinema by cinema id' do
    cinema = Cinema.create(30698, 'Prince Charles Cinema', 'http://www.princecharlescinema.com/', 'London', 'WC2H 7BY')
    expect(Cinema.find_by_cinema_id(30698)).to eq(cinema)
  end

  it 'can check if a cinema exists in table' do
    cinema = Cinema.create(30698, 'Prince Charles Cinema', 'http://www.princecharlescinema.com/', 'London', 'WC2H 7BY')
    expect(Cinema.cinema_exists?(30698)).to be(true)
  end

  after(:each) do
    DatabaseConnection.query('TRUNCATE cinemas RESTART IDENTITY CASCADE;')
  end
end
