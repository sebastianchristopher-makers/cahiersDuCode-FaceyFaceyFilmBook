CREATE TABLE followers(
  id SERIAL PRIMARY KEY,
  FOREIGN KEY (userId)
  REFERENCES users(id),
  FOREIGN KEY (followerId)
  REFERENCES users(id),
);