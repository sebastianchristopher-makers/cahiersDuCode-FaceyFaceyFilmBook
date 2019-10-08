CREATE TABLE reviews(
  id SERIAL PRIMARY KEY,
  FOREIGN KEY (filmID)
  REFERENCES films(filmId),
  FOREIGN KEY (userID)
  REFERENCES users(id),
  reviewContent TEXT
);