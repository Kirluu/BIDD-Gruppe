-- USER AGE
-- age group (10-17)
UPDATE user
SET age=10+FLOOR(RAND()*8)
WHERE age=1;

-- age group (18-24)
UPDATE user
SET age=18+FLOOR(RAND()*7)
WHERE age=18;

-- age group (25-34)
UPDATE user
SET age=25+FLOOR(RAND()*10)
WHERE age=25;

-- age group (35-44)
UPDATE user
SET age=35+FLOOR(RAND()*10)
WHERE age=35;

-- age group (45-49)
UPDATE user
SET age=45+FLOOR(RAND()*5)
WHERE age=45;

-- age group (50-55)
UPDATE user
SET age=50+FLOOR(RAND()*6)
WHERE age=50;

-- age group (56-85)
UPDATE user
SET age=56+FLOOR(RAND()*30)
WHERE age=56;

-- MEAN INCOME
CREATE TABLE zipcodedata (
	zip char(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci,
	mean int(11),
	pop int(11),
	PRIMARY KEY(zip)
);

LOAD DATA LOCAL INFILE 'C:/Users/malthe/Documents/GitHub/BIDD-Gruppe/Assignments/Assignment 4/MeanZIP-3.csv'
INTO TABLE zipcodedata
FIELDS TERMINATED BY ';';