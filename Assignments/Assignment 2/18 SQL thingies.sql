// Ja.

1.
SELECT COUNT(*)
FROM Production
WHERE language='Danish';

2.
SELECT *
FROM Production p, (
	SELECT COUNT(*)
	FROM Ratings
	WHERE productionId = p.Id)
GROUP BY year;

3.
SELECT *
FROM Production pro, Role r, Person per
WHERE pro.Id = r.productionId AND per.Id = r.personId AND r.acting=true AND (per.name='John Travolta' AND NOT per.name='Uma Thurman') OR (per.name='Uma Thurman' AND NOT per.name='John Travolta');

3.1.
SELECT *
FROM Production pro
INNER JOIN Role r ON pro.id = r.productionId
INNER JOIN Person per1, per2 ON r.personId = per1.id OR r.personId = per2.id
WHERE r.acting=true AND (per1.name='John Travolta' AND NOT per2.name='Uma Thurman') OR (per1.name='Uma Thurman' AND NOT per2.name='John Travolta');


3.2
SELECT *
FROM Production production
WHERE production.id IN   (SELECT *
						  FROM Production pro
						  INNER JOIN Role r ON pro.id = r.productionId
						  INNER JOIN Person per ON r.personId = per.id
						  WHERE per.name = 'John Travolta' OR per.name = 'Uma Thurman')
AND production.id NOT IN (SELECT *
						  FROM Production pro
						  INNER JOIN Role r ON pro.id = r.productionId
						  INNER JOIN Person per1, per2 ON r.personId = per1.id OR r.personId = per2.id
						  WHERE per1.name='John Travolta' AND per1.name='Uma Thurman');

4.
SELECT COUNT(*)
FROM Person p
INNER JOIN Role r ON p.id = r.personId
WHERE p.name LIKE 'C%';

5.
SELECT per.name, per.birthdate
FROM (Person per
INNER JOIN Role r ON r.personId = per.id
INNER JOIN Production pro ON pro.id = r.productionId)
WHERE pro.name='Pulp Fiction'
ORDER BY ascending;

6.
SELECT jomuelLJackvolta.title, jomuelLJackvolta.year
FROM((SELECT *
	  FROM Production pro
	  INNER JOIN Role r ON pro.id = r.productionId
	  INNER JOIN Person per ON r.personId = per.id
	  WHERE per.name = 'John Travolta')
	  INTERSECT
	 (SELECT *
	  FROM Production pro
	  INNER JOIN Role r ON pro.id = r.productionId
	  INNER JOIN Person per ON r.personId = per.id
	  WHERE per.name='Samuel L Jackson')) jomuelLJackvolta;
WHERE jomuelLJackvolta.year >= 1980;

7.
SELECT userId, COUNT(*) c
FROM Rating
GROUP BY userId HAVING c <= 10;

8.
SELECT *
FROM Production
WHERE year < 2000 AND year >= 1990 ORDER BY imdbRank desc LIMIT 5;

9.
SELECT *
FROM Production, (SELECT COUNT(*) FROM Rating GROUP BY productionId) votesPerProd
WHERE id = (SELECT productionId, AVG(rating) avg
			FROM Rating
			GROUP BY productionId ORDER BY avg desc LIMIT 5).productionId
AND 