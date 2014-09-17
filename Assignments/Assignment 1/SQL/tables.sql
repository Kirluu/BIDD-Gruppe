CREATE TABLE IF NOT EXISTS Person (
	id INT AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	birthdate DATETIME,
	deathdate DATETIME,
	gender BOOLEAN,
	height INT,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Contract (
	id INT AUTO_INCREMENT,
	personId INT NOT NULL,
	productionId INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (personId) REFERENCES Person.id,
	FOREIGN KEY (productionId) REFERENCES Production.id
);

CREATE TABLE IF NOT EXISTS Actor (
	contractId INT NOT NULL,
	characterName VARCHAR(50) NOT NULL,
	PRIMARY KEY (contractId, characterName),
	FOREIGN KEY (contractId) REFERENCES Contract.id
);

CREATE TABLE IF NOT EXISTS Non_Actor (
	contractId INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	PRIMARY KEY (contractId, title),
	FOREIGN KEY (contractId) REFERENCES Contract.id
);

CREATE TABLE IF NOT EXISTS Production (
	id INT AUTO_INCREMENT,
	length DOUBLE,
	title VARCHAR(80) NOT NULL,
	releaseDate DATETIME,
	country VARCHAR(50),
	language VARCHAR(50),
	imdbRanking DOUBLE,
	ageRating VARCHAR(4),
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Genre (
	productionId INT NOT NULL,
	genreTypeId INT NOT NULL,
	PRIMARY KEY (productionId, genreTypeId),
	FOREIGN KEY (productionId) REFERENCES Production.id,
	FOREIGN KEY (genresId) REFERENCES GenreType.id
);

CREATE TABLE IF NOT EXISTS GenreType (
	id INT AUTO_INCREMENT,
	genreName VARCHAR(25) NOT NULL,
	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS Movie (
	id INT AUTO_INCREMENT,
	productionId INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (productionId) REFERENCES Production.id
);

CREATE TABLE IF NOT EXISTS Series (
	id INT AUTO_INCREMENT,
	productionId INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (productionId) REFERENCES Production.id
);

CREATE TABLE IF NOT EXISTS Season (
	id INT AUTO_INCREMENT,
	seriesId INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (seriesId) REFERENCES Series.id
);

CREATE TABLE IF NOT EXISTS Episode (
	id INT AUTO_INCREMENT,
	seasonId INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (seasonId) REFERENCES Season.id
);