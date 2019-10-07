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

  it "can return the correct id" do
    user = User.create("chris@example.com", "Password1234")
    expect(user.id).to eq(1)
  end

  it "can authenticate a user" do
    user = User.create("chris@example.com", "Password1234")
    expect(User.authenticate("chris@example.com", "Password1234")).to be_a(User)
  end

  it "wont authenticate an incorrect password" do
    user = User.create("chris@example.com", "Password1234")
    expect(User.authenticate("chris@example.com", "foobar")).to be(nil)
  end

  it "can check if a user exists" do
    user = User.create("chris@example.com", "Password1234")
    expect(User.user_exists?("chris@example.com")).to be true
  end

  it "can check if a user does not exist" do
    expect(User.user_exists?("christest@example.com")).to be false
  end

  it "do something i forgot what" do
    user = User.create("chris@example.com", "Password1234")
    expect(User.find_by_email("chris@example.com")).to eq(user)
  end

  after(:each) do
    DatabaseConnection.query("TRUNCATE users RESTART IDENTITY CASCADE;")
  end

end
