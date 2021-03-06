CREATE TABLE IF NOT EXISTS Production (
	id INT AUTO_INCREMENT,
	length DOUBLE,
	title VARCHAR(80) NOT NULL,
	releaseDate DATETIME,
	country VARCHAR(50),
	language VARCHAR(50),
	imdbRating DOUBLE,
	ageRating VARCHAR(4),
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Person (
	id INT AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	birthdate DATETIME,
	deathdate DATETIME,
	gender BOOLEAN,
	height INT,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Role (
	id INT AUTO_INCREMENT,
	personId INT,
	acting BOOLEAN NOT NULL,
	roleName VARCHAR(25),
	PRIMARY KEY (id, roleName),
	FOREIGN KEY (personId) REFERENCES Person(id)
);

CREATE TABLE IF NOT EXISTS Contract (
	id INT AUTO_INCREMENT,
	roleId INT,
	productionId INT,
	PRIMARY KEY (id),
	FOREIGN KEY (roleId) REFERENCES Role(id),
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