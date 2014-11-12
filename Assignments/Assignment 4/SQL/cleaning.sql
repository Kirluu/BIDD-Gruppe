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

-- zipcodedata
DELETE FROM zipcodedata
WHERE NOT EXISTS (
	SELECT zip FROM zipcode
	WHERE zip = zipcodedata.zip
);