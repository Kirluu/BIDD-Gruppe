-- Facts table
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

-- Aggregate
-- genre view
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

CREATE INDEX genreNameIndex ON genreview (genreName);
CREATE INDEX movieCountIndex ON genreview (movieCount);
CREATE INDEX ratingCountIndex ON genreview (ratingCount);
CREATE INDEX ratingMeanIndex ON genreview (ratingMean);
CREATE INDEX userSalaryMeanIndex ON genreview (userSalaryMean);
CREATE INDEX userAgeMeanIndex ON genreview (userAgeMean);
CREATE INDEX userLattitudeMeanIndex ON genreview (userLattitudeMean);
CREATE INDEX userLongitudeMeanIndex ON genreview (userLongitudeMean);
CREATE INDEX zipPopMeanIndex ON genreview (zipPopMean);

-- zip view
CREATE TABLE zipcodeview (
	zip INT(11),
	city VARCHAR(64),
	state CHAR(2),
	population INT(11),
	totalUsers INT(11),
	userAgeMean FLOAT,
	userLattitudeMean FLOAT,
	userLongitudeMean FLOAT,
	totalRatings INT(11),
	ratingMean FLOAT
);

INSERT INTO zipcodeview (
	SELECT
		facts.zip,
		zipcode.city,
		zipcode.state,
		zipcodedata.pop,
		COUNT(DISTINCT user.id),
		AVG(user.age),
		AVG(zipcode.lattitude),
		AVG(zipcode.longitude),
		COUNT(DISTINCT rating.userId, rating.movieId),
		AVG(rating.rating)
	FROM ratingfacts AS facts
	JOIN zipcode ON zipcode.zip = facts.zip
	JOIN zipcodedata ON zipcodedata.zip = facts.zip
	JOIN user ON user.id = facts.userId
	JOIN rating ON rating.userId = facts.userId AND rating.movieId = facts.movieId
	GROUP BY zipcode.zip
);

CREATE INDEX zipIndex ON zipcodeview (zip);
CREATE INDEX cityIndex ON zipcodeview (city);
CREATE INDEX stateIndex ON zipcodeview (state);
CREATE INDEX populationIndex ON zipcodeview (population);
CREATE INDEX totalUsersIndex ON zipcodeview (totalUsers);
CREATE INDEX userAgeMeanIndex ON zipcodeview (userAgeMean);
CREATE INDEX userLattitudeMeanIndex ON zipcodeview (userLattitudeMean);
CREATE INDEX userLongitudeMeanIndex ON zipcodeview (userLongitudeMean);
CREATE INDEX totalRatingsIndex ON zipcodeview (totalRatings);
CREATE INDEX ratingMeanIndex ON zipcodeview (ratingMean);

-- user view
CREATE TABLE userview (
	id INT(11),
	age FLOAT,
	occupation VARCHAR(20),
	lattitudeMean FLOAT,
	longitudeMean FLOAT,
	zip INT(11),
	city VARCHAR(64),
	state CHAR(2),
	population INT(11),
	totalRatings INT(11),
	ratingMean FLOAT
);

INSERT INTO userview (
	SELECT
		user.id,
		user.age,
		occupation.description,
		zipcode.lattitude,
		zipcode.longitude,
		zipcode.zip,
		zipcode.city,
		zipcode.state,
		zipcodedata.pop,
		COUNT(DISTINCT rating.userId, rating.movieId),
		AVG(rating.rating)
	FROM ratingfacts AS facts
	JOIN user ON user.id = facts.userId
	JOIN occupation ON occupation.id = user.occupation
	JOIN zipcode ON zipcode.zip = user.zip
	JOIN zipcodedata ON zipcodedata.zip = user.zip
	JOIN rating ON rating.userId = facts.userId AND rating.movieId = facts.movieId
	JOIN moviegenre ON moviegenre.movieId = rating.movieId
	GROUP BY facts.userId
);

CREATE INDEX idIndex ON userview (id);
CREATE INDEX ageIndex ON userview (age);
CREATE INDEX occupationIndex ON userview (occupation);
CREATE INDEX lattitudeMeanIndex ON userview (lattitudeMean);
CREATE INDEX longitudeMeanIndex ON userview (longitudeMean);
CREATE INDEX zipIndex ON userview (zip);
CREATE INDEX cityIndex ON userview (city);
CREATE INDEX stateIndex ON userview (state);
CREATE INDEX populationIndex ON userview (population);
CREATE INDEX totalRatingsIndex ON userview (totalRatings);
CREATE INDEX ratingMeanIndex ON userview (ratingMean);