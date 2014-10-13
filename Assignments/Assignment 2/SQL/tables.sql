CREATE TABLE IF NOT EXISTS Production (
	id INT AUTO_INCREMENT,
	length DOUBLE,
	title VARCHAR(300) NOT NULL,
	year INT,
	releaseDate DATE,
	country VARCHAR(50),
	language VARCHAR(50),
	imdbRating DOUBLE,
	ageRating VARCHAR(4),
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Reference (
	fromId INT,
	toId INT,
	FOREIGN KEY(fromId) REFERENCES Production(id),
	FOREIGN KEY(toId) REFERENCES Production(id)
);

CREATE TABLE IF NOT EXISTS User (
	id INT AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Rating (
	productionId INT,
	userId INT,
	rating INT NOT NULL,
	FOREIGN KEY(productionId) REFERENCES Production(id),
	FOREIGN KEY(userId) REFERENCES User(id)
);

CREATE TABLE IF NOT EXISTS Person (
	id INT AUTO_INCREMENT,
	name VARCHAR(200) NOT NULL,
	birthdate DATE,
	deathdate DATE,
	gender char(1),
	height INT,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Role (
	personId INT,
	productionId INT,
	roleName VARCHAR(50),
	PRIMARY KEY (personId, productionId, roleName),
	FOREIGN KEY (personId) REFERENCES Person(id),
	FOREIGN KEY (productionId) REFERENCES Production(id)
);

CREATE TABLE IF NOT EXISTS GenreType (
	id INT AUTO_INCREMENT,
	genreName VARCHAR(25) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Genre (
	productionId INT,
	genreTypeId INT,
	PRIMARY KEY (productionId, genreTypeId),
	FOREIGN KEY (productionId) REFERENCES Production(id),
	FOREIGN KEY (genreTypeId) REFERENCES GenreType(id)
);

CREATE TABLE IF NOT EXISTS Movie (
	id INT AUTO_INCREMENT,
	productionId INT,
	PRIMARY KEY (id),
	FOREIGN KEY (productionId) REFERENCES Production(id)
);

CREATE TABLE IF NOT EXISTS Series (
	id INT AUTO_INCREMENT,
	productionId INT,
	PRIMARY KEY (id),
	FOREIGN KEY (productionId) REFERENCES Production(id)
);

CREATE TABLE IF NOT EXISTS Season (
	id INT AUTO_INCREMENT,
	seriesId INT,
	PRIMARY KEY (id),
	FOREIGN KEY (seriesId) REFERENCES Series(id)
);

CREATE TABLE IF NOT EXISTS Episode (
	id INT AUTO_INCREMENT,
	seasonId INT,
	PRIMARY KEY (id),
	FOREIGN KEY (seasonId) REFERENCES Season(id)
);