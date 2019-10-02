CREATE TABLE usersFilms(
  id SERIAL PRIMARY KEY,
  userId INTEGER REFERENCES users (id),
  filmId INTEGER
);
