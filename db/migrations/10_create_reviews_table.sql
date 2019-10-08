CREATE TABLE reviews(
  id SERIAL PRIMARY KEY,
  filmID INTEGER
  REFERENCES films(filmId),
  userID INTEGER
  REFERENCES users(id),
  reviewContent TEXT
);