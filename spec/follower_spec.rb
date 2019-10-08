require 'follow'
require 'user'
describe Follower do
    it "can create a new follower" do
        user1 = User.create("test1@test.com", "pass")
        user2 = User.create("test2@test.com", "pass")

        follower = Follower.add(1, 2)
        expect(follower).to be_a(Follower)
    end

    it "can return all followers" do
        user1 = User.create("test1@test.com", "pass")
        user2 = User.create("test2@test.com", "pass")
        user3 = User.create("test3@test.com", "pass")
        user4 = User.create("test4@test.com", "pass")
        follower1 = Follower.add(user1.id, user2.id)
        follower2 = Follower.add(user1.id, user3.id)
        follower3 = Follower.add(user1.id, user4.id)
        expect(Follower.find_by_user_id(1)).to contain_exactly(follower1, follower2, follower3)
    end
    after(:each) do
        DatabaseConnection.query('TRUNCATE users RESTART IDENTITY CASCADE;')
        DatabaseConnection.query('TRUNCATE followers RESTART IDENTITY CASCADE;')

      end
end