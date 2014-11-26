CREATE TABLE genregroup (
	groupId INT(11),
	genreId INT(11),
    PRIMARY KEY (groupId, genreId),
	FOREIGN KEY (genreId) REFERENCES genre(id)
);

CREATE TABLE ratingfacts (
	movieId INT(11),
	userId INT(11),
	genreGroupId INT(11),
	occupationId INT(11),
	zip CHAR(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci,
	FOREIGN KEY (movieId) REFERENCES movie(id),
	FOREIGN KEY (userId) REFERENCES user(id),
	FOREIGN KEY (genreGroupId) REFERENCES genregroup(groupId),
	FOREIGN KEY (occupationId) REFERENCES occupation(id),
	FOREIGN KEY (zip) REFERENCES zipcode(zip)
);

INSERT INTO genregroup (

);

SELECT * FROM movie
JOIN moviegenre ON moviegenre.movieId = movie.id
GROUP BY movie.id;



INSERT INTO ratingfacts
SELECT rating.movieId, rating.userId, genreGroupId, occupation.id as occupation, zipcode.zip
FROM rating
JOIN user ON user.id = rating.userId
JOIN occupation ON occupation.id = user.occupation
JOIN zipcode ON zipcode.zip = user.zip
JOIN (SELECT 1 AS genreGroupId) AS s1;

-- Lulz:
SELECT 1000/pop * COUNT(*) AS ratingsPerPerson, ratingfacts.zip, COUNT(*) AS ratings, pop AS population
FROM ratingfacts
JOIN zipcodedata ON zipcodedata.zip = ratingfacts.zip
GROUP BY zipcodedata.zip
ORDER BY ratingsPerPerson DESC;

SELECT title, rating FROM ratingfacts
JOIN rating ON rating.movieId = ratingfacts.movieId AND rating.userId = ratingfacts.userId
JOIN movie ON movie.id = ratingfacts.movieId
WHERE zip = 10020;