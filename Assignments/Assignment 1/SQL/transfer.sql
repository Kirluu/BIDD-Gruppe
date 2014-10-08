INSERT Production (id, title, year, releaseDate, country, language, imdbRating)
SELECT id, title, year, releaseDate, country, language, imdbRank
FROM imdb.movie;

INSERT GenreType (genreName)
SELECT DISTINCT(genre)
FROM imdb.genre;

INSERT IGNORE Genre (productionId, genreTypeId)
SELECT movieId, id
FROM (
	SELECT * FROM GenreType
	JOIN imdb.Genre ON GenreType.genreName = imdb.Genre.genre
) AS r3d3;

INSERT Person (id, name, gender, height, birthdate, deathdate)
SELECT id, name, gender, height, birthdate, deathdate
FROM imdb.Person;

INSERT User (name)
SELECT DISTINCT(user)
FROM imdb.ratings;

INSERT Rating (productionId, userId, rating)
SELECT movieId, id, rating
FROM (
	SELECT * FROM User
	NATURAL JOIN (
		SELECT user AS name, movieId, rating FROM imdb.Ratings
	) natjoin
) r4d6
WHERE EXISTS (
	SELECT * FROM Production
	WHERE movieId = Production.id);

INSERT Role (personId, productionId, roleName)
SELECT personId, movieId, role
FROM imdb.Involved;






drop database itumdb;
create database itumdb;
use itumdb;