CREATE TABLE followers(
  id SERIAL PRIMARY KEY,
  userId INTEGER
  REFERENCES users(id),
  followerId INTEGER
  REFERENCES users(id)
);