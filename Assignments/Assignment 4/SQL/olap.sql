CREATE TABLE ratingfacts (
	movieId INT(11),
	userId INT(11),
	genreId INT(11),
	occupationId INT(11),
	zip CHAR(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci,
	FOREIGN KEY (movieId) REFERENCES movie(id),
	FOREIGN KEY (userId) REFERENCES user(id),
	FOREIGN KEY (genreId) REFERENCES genre(id),
	FOREIGN KEY (occupationId) REFERENCES occupation(id),
	FOREIGN KEY (zip) REFERENCES zipcode(zip)
);

INSERT INTO ratingfacts
SELECT rating.movieId, rating.userId, moviegenre.genreId, occupation.id as occupation, zipcode.zip
FROM rating
JOIN user ON user.id = rating.userId
JOIN moviegenre ON moviegenre.movieId = rating.movieId
JOIN occupation ON occupation.id = user.occupation
JOIN zipcode ON zipcode.zip = user.zip;


SELECT 1000/pop * COUNT(*) ratingsPerThousandPerson, ratingfacts.zip, COUNT(*) ratings, pop population
FROM ratingfacts
JOIN zipcodedata ON zipcodedata.zip = ratingfacts.zip
GROUP BY zipcodedata.zip
ORDER BY ratingsPerThousandPerson DESC;

SELECT 1000/mean * COUNT(*) ratingsPerThousandDollars, ratingfacts.zip, mean meanIncome, COUNT(*) ratings FROM ratingfacts
JOIN zipcodedata ON zipcodedata.zip = ratingfacts.zip
GROUP BY ratingfacts.zip
ORDER BY ratingsPerThousandDollars DESC;


-- Aggregate
-- genre
CREATE TABLE genreview (
	genreName VARCHAR(20),
	movieCount INT(11),
	ratingCount INT(11),
	ratingMean FLOAT,
	userSalaryMean INT(11),
	userAgeMean FLOAT,
	userLattitudeMean FLOAT,
	userLongitudeMean FLOAT,
	zipPopMean INT(11)
);

INSERT INTO genreview (
	SELECT
		genre.name,
		COUNT(DISTINCT facts.movieId),
		COUNT(DISTINCT facts.movieId, facts.userId),
		AVG(rating.rating),
		AVG(zipcodedata.mean),
		AVG(user.age),
		AVG(zipcode.lattitude),
		AVG(zipcode.longitude),
		AVG(zipcodedata.pop)
	FROM ratingfacts AS facts
	JOIN genre ON genre.id = facts.genreId
	JOIN rating ON rating.userId = facts.userId AND rating.movieId = facts.movieId
	JOIN zipcode ON zipcode.zip = facts.zip
	JOIN zipcodedata ON zipcodedata.zip = facts.zip
	JOIN user ON user.id = facts.userId
	GROUP BY genreId
);

-- zip
CREATE TABLE zipcodeview (
	zip INT(11),
	city VARCHAR(64),
	state CHAR(2),
	population INT(11),
	mostFavouredGenre VARCHAR(20),
	leastFavouredGenre VARCHAR(20),
	userAgeMean FLOAT,
	userLattitudeMean FLOAT,
	userLongitudeMean FLOAT,
	ratingMean FLOAT
);

INSERT INTO zipcodeview (
	SELECT
		facts.zip,
		zipcode.city,
		zipcode.state,
		zipcodedata.pop,
		mostFavId,
		leastFavId,
		AVG(user.age),
		AVG(zipcode.lattitude),
		AVG(zipcode.longitude),
		AVG(rating.rating)
	FROM ratingfacts AS facts
	JOIN zipcode ON zipcode.zip = facts.zip
	JOIN zipcodedata ON zipcodedata.zip = facts.zip
	JOIN user ON user.id = facts.userId
	JOIN rating ON rating.userId = facts.userId AND rating.movieId = facts.movieId
	JOIN (
		SELECT user.zip, ratingfacts.genreId mostFavId, MAX(average) mostFavRating
		FROM ratingfacts
		JOIN user ON ratingfacts.userId = user.id
		JOIN (
			SELECT user.zip AS userZip, ratingfacts.genreId AS theGenreId, AVG(rating.rating) AS average
			FROM ratingfacts
		    JOIN rating ON rating.userId = ratingfacts.userId AND rating.movieId = ratingfacts.movieId
			JOIN user ON rating.userId = user.id
			GROUP BY user.zip, ratingfacts.genreId
			) AS s1_1 ON s1_1.theGenreId = ratingfacts.genreId AND s1_1.userZip = user.zip
		GROUP BY user.zip, s1_1.theGenreId
        ORDER BY mostFavRating DESC
	) AS s1_2 ON facts.zip = s1_2.zip
	JOIN (
		SELECT user.zip, ratingfacts.genreId leastFavId, MIN(average) leastFavRating
		FROM ratingfacts
		JOIN user ON ratingfacts.userId = user.id
		JOIN (
			SELECT user.zip AS userZip, ratingfacts.genreId AS theGenreId, AVG(rating.rating) AS average
			FROM ratingfacts
		    JOIN rating ON rating.userId = ratingfacts.userId AND rating.movieId = ratingfacts.movieId
			JOIN user ON rating.userId = user.id
			GROUP BY user.zip, ratingfacts.genreId
			) AS s2_1 ON s2_1.theGenreId = ratingfacts.genreId AND s2_1.userZip = user.zip
		GROUP BY user.zip
	) AS s2_2 ON facts.zip = s2_2.zip
	GROUP BY zipcode.zip
);