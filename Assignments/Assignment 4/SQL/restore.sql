drop database movielens;
create database movielens;
use movielens;
source C:/Users/malthe/Desktop/movielens.sql;

-- PRIMARY KEYS
-- genre
ALTER TABLE genre
ADD PRIMARY KEY (id);

-- movie
ALTER TABLE movie
ADD PRIMARY KEY (id);

-- moviegenre
ALTER TABLE moviegenre
ADD PRIMARY KEY (genreId, movieId);

-- occupation
ALTER TABLE occupation
ADD PRIMARY KEY (id);

-- rating
ALTER TABLE rating
ADD PRIMARY KEY (userId, movieId);

-- user
ALTER TABLE user
ADD PRIMARY KEY (id);

-- zipcode
ALTER TABLE zipcode
ADD PRIMARY KEY (zip);


-- NOT NULL
-- genre
DELETE FROM genre
WHERE name IS NULL;

ALTER TABLE genre
MODIFY name VARCHAR(20) NOT NULL;

-- movie
DELETE FROM movie
WHERE title IS NULL;

ALTER TABLE movie
MODIFY title VARCHAR(127) NOT NULL;

-- occupation
DELETE FROM occupation
WHERE description IS NULL;

ALTER TABLE occupation
MODIFY description VARCHAR(20) NOT NULL;

-- rating
DELETE FROM rating
WHERE rating IS NULL;

ALTER TABLE rating
MODIFY rating INT(11) NOT NULL;


-- CLEANING
-- user
DELETE FROM user
WHERE NOT EXISTS (
	SELECT id FROM occupation
	WHERE id = user.occupation
);

DELETE FROM user
WHERE NOT EXISTS (
	SELECT zip FROM zipcode
	WHERE zip = user.zip
);

-- rating
DELETE FROM rating
WHERE NOT EXISTS (
	SELECT id FROM user
	WHERE id = rating.userId
);

DELETE FROM rating
WHERE NOT EXISTS (
	SELECT id FROM movie
	WHERE id = rating.movieId
);

-- moviegenre
DELETE FROM moviegenre
WHERE NOT EXISTS (
	SELECT id FROM genre
	WHERE id = moviegenre.genreId
);

DELETE FROM moviegenre
WHERE NOT EXISTS (
	SELECT id FROM movie
	WHERE id = moviegenre.movieId
);


-- FOREIGN KEYS
-- moviegenre
ALTER TABLE moviegenre
ADD FOREIGN KEY (genreId)
REFERENCES genre(id);

ALTER TABLE moviegenre
ADD FOREIGN KEY (movieId)
REFERENCES movie(id);

-- rating
ALTER TABLE rating
ADD FOREIGN KEY (userId)
REFERENCES user(id);

ALTER TABLE rating
ADD FOREIGN KEY (movieId)
REFERENCES movie(id);

-- user
ALTER TABLE user
ADD FOREIGN KEY (occupation)
REFERENCES occupation(id);

ALTER TABLE user
ADD FOREIGN KEY (zip)
REFERENCES zipcode(zip);