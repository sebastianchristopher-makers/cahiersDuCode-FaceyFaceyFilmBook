CREATE TABLE films(
  id SERIAL PRIMARY KEY,
  filmId INTEGER,
  title VARCHAR,
  posterPath VARCHAR,
  year INTEGER,
  UNIQUE (filmID)
);
