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