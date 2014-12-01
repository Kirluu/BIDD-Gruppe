-- MEAN INCOME
CREATE TABLE zipcodedata (
	zip char(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci,
	mean int(11),
	pop int(11),
	PRIMARY KEY(zip)
);

LOAD DATA LOCAL INFILE '<FILE LOCATION>'
INTO TABLE zipcodedata
FIELDS TERMINATED BY ';';

-- Clean
DELETE FROM zipcodedata
WHERE NOT EXISTS (
	SELECT zip FROM zipcode
	WHERE zip = zipcodedata.zip
);

-- Foreign key
ALTER TABLE zipcodedata
ADD FOREIGN KEY (zip)
REFERENCES zipcode(zip);