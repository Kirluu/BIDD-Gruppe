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