CREATE TABLE showtime(
  id SERIAL PRIMARY KEY,
  movieId INTEGER REFERENCES films(filmId),
  cinemaID INTEGER REFERENCES cinemas(cinemaId),
  startAt TEXT,
  auditorium VARCHAR,
  bookingLink VARCHAR,
  website VARCHAR,
  cinemaName TEXT,
  city VARCHAR,
  zipCode VARCHAR(10)
);
