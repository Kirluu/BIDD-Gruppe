-- Fun facts
-- Most rating user
SELECT totalRatings, age, city, state, occupation FROM userview
ORDER BY totalRatings DESC
LIMIT 1;

-- Mean ratings by occupation
SELECT AVG(totalRatings) meanRatings, occupation
FROM userview
GROUP BY occupation
ORDER BY meanRatings DESC;

-- Mean rating score by occupation
SELECT AVG(ratingMean) meanRatingScore, occupation
FROM userview
GROUP BY occupation
ORDER BY meanRatingScore DESC;

-- Top mean rating by genre Sci-Fi
SELECT genre.name, occupation.description, AVG(rating.rating) meanRating
FROM ratingfacts AS facts
JOIN genre ON genre.id = facts.genreId
JOIN user ON user.id = facts.userId
JOIN occupation ON occupation.id = user.occupation
JOIN rating ON rating.userId = facts.userId AND rating.movieId = facts.movieId
WHERE genre.name = "Sci-Fi"
GROUP BY occupation.id
ORDER BY meanRating DESC
LIMIT 1;

-- Most rated genre by the city with more than 0 ratings with the lowest income
SELECT facts.zip, zipcode.city, zipcode.state, genre.name genre, zipcodedata.mean meanIncome,
	   COUNT(DISTINCT facts.userId, facts.movieId) ratings
FROM ratingfacts AS facts
JOIN zipcode ON zipcode.zip = facts.zip
JOIN zipcodedata ON zipcodedata.zip = facts.zip
JOIN moviegenre ON moviegenre.movieId = facts.movieId
JOIN genre ON genre.id = moviegenre.genreId
WHERE facts.zip = (
	SELECT zip FROM (
		SELECT zip, mean meanSalary
		FROM zipcodedata
        WHERE EXISTS (SELECT * FROM rating JOIN user ON user.id = rating.userId WHERE user.zip = zipcodedata.zip)
		ORDER BY meanSalary DESC
		LIMIT 1
	) AS s1
)
GROUP BY genre.id
ORDER BY ratings DESC
LIMIT 1;