require 'review'

describe Review do
  before(:each) do
    DatabaseConnection.query("INSERT INTO films(filmid) VALUES($1);",[1])
    DatabaseConnection.query("INSERT INTO users(email) VALUES($1);",['chris@example.com'])
  end

  it 'can create a review' do
    review = Review.create(1,1,'Foobar')
    expect(review).to be_a(Review)
  end

  it 'can find a review by id' do
    review = Review.create(1,1,'Foobar')
    found_review = Review.find_by_id(1)
    expect(found_review).to eq(review)
  end

  it 'returns nil if no id exists' do
    found_review = Review.find_by_id(1)
    expect(found_review).to be_nil
  end

  it 'can find a review by a filmID' do
    review = Review.create(1,1,'Foobar')
    found_review = Review.find_by_film_id(1)
    expect(found_review).to include(review)
  end

  it 'can find a review by a user id' do
    review = Review.create(1,1,'Foobar')
    found_review = Review.find_by_user_id(1)
    expect(found_review).to include(review)
  end

  context 'after review has been created' do
    before(:each) do
      Review.create(1,1,'Foobar')
    end
    let(:review) { Review.find_by_id(1) }

    it 'has an id' do
      expect(review.id).to eq(1)
    end

    it 'has a film id' do
      expect(review.film_id).to eq(1)
    end

    it 'has a user id' do
      expect(review.user_id).to eq(1)
    end

    it 'has a review content' do
      expect(review.review_content).to eq('Foobar')
    end
  end

  after(:each) do
    DatabaseConnection.query('TRUNCATE reviews RESTART IDENTITY CASCADE;')
    DatabaseConnection.query('TRUNCATE films RESTART IDENTITY CASCADE;')
    DatabaseConnection.query('TRUNCATE users RESTART IDENTITY CASCADE;')
  end
end
