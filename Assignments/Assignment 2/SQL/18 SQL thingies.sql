-- 1.
SELECT COUNT(*)
FROM Production
WHERE language='Danish';

-- 2
SELECT year, COUNT(*)
FROM Production
INNER JOIN Rating ON id = productionId
GROUP BY year;

-- 3
SELECT * FROM (
	SELECT id, title FROM production
	WHERE id IN (
		SELECT id FROM production
		WHERE id IN (
			SELECT productionId FROM role
			WHERE personId IN (
				SELECT id FROM person WHERE name="John Travolta" OR name="Uma Thurman")))) s1
WHERE NOT EXISTS (
	SELECT * FROM (SELECT id FROM production 
	WHERE id IN (
		SELECT r1.productionId FROM role r1
		INNER JOIN role r2 on r1.productionId = r2.productionId 
		WHERE r1.personId=(
			SELECT id FROM person WHERE name="John Travolta") AND r2.personId=(
				SELECT id FROM person WHERE name="Uma Thurman"))) s2 
	WHERE s1.id=s2.id);

-- 4.
SELECT COUNT(*) FROM (
	SELECT * FROM Person p
	INNER JOIN Role r ON p.id = r.personId
	WHERE p.name LIKE 'C%' AND (r.roleName = 'actor' OR  r.roleName = 'director')
	GROUP BY p.id) s1;

-- 5.
SELECT per.name, YEAR(per.birthdate)
FROM (Person per
INNER JOIN Role r ON r.personId = per.id
INNER JOIN Production pro ON pro.id = r.productionId)
WHERE pro.title='Pulp Fiction'
ORDER BY per.birthdate ASC;

-- 6
SELECT pro1.title, pro1.year
FROM(
	(production pro1
	  INNER JOIN Role r1 ON pro1.id = r1.productionId
	  INNER JOIN person per1 ON r1.personId = per1.id
	  AND per1.name = 'John Travolta')
	  INNER JOIN
	 (production pro2
	  INNER JOIN Role r2 ON pro2.id = r2.productionId
	  INNER JOIN person per2 ON r2.personId = per2.id
	  AND per2.name='Samadu Jackson') 
	 ON pro1.id = pro2.id
	 ) WHERE pro1.year >= 1980
	ORDER BY year asc;

-- 7.
SELECT COUNT(*) FROM (
	SELECT userId, COUNT(*) c
	FROM Rating
	GROUP BY userId HAVING c <= 10) s1;

-- 8.
SELECT title, imdbRating
FROM Production
WHERE year < 2000 AND year >= 1990 ORDER BY imdbRating desc LIMIT 5;

-- 9.
SELECT AVG(rating) rating, (SELECT title FROM Production WHERE id = productionId) title, COUNT(*) amount
FROM Rating
GROUP BY productionId HAVING amount >= 4
ORDER BY rating desc
LIMIT 5;

-- 10.
SELECT pro.language, AVG(pro.imdbRating) average
FROM Production pro
WHERE pro.year = 1994
GROUP BY pro.language
ORDER BY average DESC;

-- 11. (not done)

-- 12.
SELECT pro.title, MAX(pro.imdbRating) AS rating
FROM Production pro
INNER JOIN Role r ON pro.id = r.productionId
INNER JOIN Person per ON r.personId = per.id
WHERE per.name = 'John Travolta';

-- 13.
SELECT COUNT(*) FROM Person
WHERE gender = 'f' AND (
	deathdate < (SELECT birthdate FROM Person WHERE name = "Charles Chaplin")
	OR birthdate > (SELECT deathdate FROM Person WHERE name = "Charles Chaplin")
);

-- 14.
SELECT gt.name, AVG(pro.imdbRating)
FROM Production pro
INNER JOIN Genre g ON pro.id = g.productionId
INNER JOIN GenreType gt ON g.genreTypeId = gt.id
GROUP BY gt.name;

-- 15.
SELECT * FROM (
	SELECT (SELECT genreName FROM GenreType WHERE id = g.genreTypeId) genre, SUM(prods.c) s
	FROM Genre g
	INNER JOIN (SELECT pro.id proId, COUNT(*) c
				FROM Production pro
				INNER JOIN Rating r ON pro.id = r.productionId
				GROUP BY pro.id) prods
	ON prods.proId = g.productionId
	GROUP BY g.genreTypeId ) s1
WHERE s >= 10
ORDER BY s DESC;

-- 16. (not done)
SELECT * FROM (
	SELECT r1.id id1, r1.fromId, r1.toId, COUNT(*) c FROM Reference r1
	INNER JOIN (SELECT r2.id id2, r2.fromId, r2.toId FROM Reference r2) s1 ON r1.toId = s1.fromId
	INNER JOIN (SELECT r3.id id3, r3.fromId, r3.toId FROM Reference r3) s2 ON s1.toId = s2.fromId
	GROUP BY r1.id) s3
ORDER BY c DESC
LIMIT 1

SELECT r1.fromId FROM Reference r1
INNER JOIN Reference r2 ON r1.toId = r2.fromId
INNER JOIN Reference r3 ON r2.toId = r3.fromId;

--(SELECT title FROM Production WHERE id = id1) title, 

-- 17. (not done)
SELECT *
FROM(	SELECT pro.id prodId1, per.id perId1
		FROM Production pro
		INNER JOIN Role r ON pro.id = r.productionId
		INNER JOIN Person per ON r.personId = per.id
		WHERE r.roleName = 'actor')
AS actors
WHERE actors.perId1 IN (SELECT per.id perId2
						FROM Production pro
						INNER JOIN Role r ON pro.id = r.productionId
						INNER JOIN Person per ON r.personId = per.id
						WHERE r.roleName = 'director');

-- 18. (not done)
SELECT s1.gId, s2.gId, (s1.c + s2.c) combined
FROM
	(SELECT pro.id pId, g.genreTypeId gId, COUNT(*) c
	FROM Production pro
	INNER JOIN Genre g ON g.productionId = pro.id
	GROUP BY gId) s1
INNER JOIN
	(SELECT pro.id pId, g.genreTypeId gId, COUNT(*) c
	FROM Production pro
	INNER JOIN Genre g ON g.productionId = pro.id
	GROUP BY pro.id) s2
ON s1.pId = s2.pId
ORDER BY combined DESC
LIMIT 1;