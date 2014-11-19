CREATE TABLE genregroup (
	id INT(11),
	genreId INT(11),
	PRIMARY KEY (id),
	FOREIGN KEY (genreId) REFERENCES genre(id)
);

CREATE TABLE ratingfacts (
	movieId INT(11),
	userId INT(11),
	genreGroupId INT(11),
	occupationId INT(11),
	zipId INT(11),
	zipDataId INT(11),
	FOREIGN KEY (movieId) REFERENCES movie(id),
	FOREIGN KEY (userId) REFERENCES user(id),
	FOREIGN KEY (genreGroupId) REFERENCES genreGroup(id),
	FOREIGN KEY (occupationId) REFERENCES occupation(id),
	FOREIGN KEY (zipId) REFERENCES zipcode(zip),
	FOREIGN KEY (zipDataId) REFERENCES zipcodedata(zip)
);