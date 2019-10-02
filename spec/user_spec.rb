require 'user'

describe User do

  before(:each) do
    @user = User.new(1, "chris@example.com")
  end

  it "initializes with a email" do
    expect(@user.email).to eq("chris@example.com")
  end

  it "initializes with an id" do
    expect(@user.id).to eq(1)
  end

  it "initializes with an empty films array" do
    expect(@user.films).to be_empty
  end

  it "creates a new user" do
    user = User.create("chris@example.com", "Password1234")
    expect(user).to be_a(User)
  end
end
