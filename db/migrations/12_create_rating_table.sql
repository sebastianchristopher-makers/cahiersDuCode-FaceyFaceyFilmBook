CREATE TABLE rating(
  id SERIAL PRIMARY KEY,
  userId INTEGER REFERENCES users(id),
  filmId INTEGER REFERENCES films(filmId),
  rating INTEGER
);
