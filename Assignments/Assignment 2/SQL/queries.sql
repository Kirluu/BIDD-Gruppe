-- 1.
SELECT COUNT(*)
FROM Production
WHERE language='Danish';

-- 2.
SELECT year, COUNT(*)
FROM Production
INNER JOIN Rating ON id = productionId
GROUP BY year;

-- 3.
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

-- 6.
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

-- 11.
SELECT DISTINCT personId
FROM Person per1 
INNER JOIN Role r1 ON r1.personId = per1.id
INNER JOIN Production pro1 ON pro1.id = r1.productionId AND pro1.title='Pulp Fiction' AND r1.roleName='actor'
WHERE per1.id NOT IN 
( 
    SELECT DISTINCT personId
    FROM 
    (
        SELECT productionId, COUNT(*) c
        FROM
        (
            SELECT r2.productionId 
            FROM
            (
                SELECT per1.id IdOfActorsInPulpFiction
                FROM Person per1
                INNER JOIN Role r1 ON r1.personId = per1.id
                INNER JOIN Production pro1 ON pro1.id = r1.productionId AND pro1.title='Pulp Fiction' AND r1.roleName='actor'         
            ) ActorsInPulpFiction
            INNER JOIN Role r2 ON IdOfActorsInPulpFiction = r2.personId
            AND r2.roleName='actor' AND r2.productionId != (SELECT id FROM production WHERE title ='Pulp Fiction')
        ) MoviesOfPulpFictionCastMinusPulpFiction
        GROUP BY productionId HAVING c > 1
    ) MoviesWithMoreThanOnePulpFictionActor 
    INNER JOIN role r3 ON r3.productionId = MoviesWithMoreThanOnePulpFictionActor.productionId
    AND r3.productionId != (SELECT id FROM production WHERE title ='Pulp Fiction')
);

-- 12.
SELECT pro.title proTitle, MAX(pro.imdbRating) rating
FROM Production pro
INNER JOIN Role r ON pro.id = r.productionId
INNER JOIN Person per ON r.personId = per.id
WHERE per.name = 'John Travolta'
GROUP BY proTitle
ORDER BY rating DESC
LIMIT 1;

-- 13.
SELECT COUNT(*) FROM Person
WHERE gender = 'f' AND (
	deathdate < (SELECT birthdate FROM Person WHERE name = "Charles Chaplin")
	OR birthdate > (SELECT deathdate FROM Person WHERE name = "Charles Chaplin")
);

-- 14.
SELECT gt.genreName, AVG(pro.imdbRating)
FROM Production pro
INNER JOIN Genre g ON pro.id = g.productionId
INNER JOIN GenreType gt ON g.genreTypeId = gt.id
GROUP BY gt.genreName;

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

-- 16.
SELECT (SELECT title FROM Production WHERE id = fromId) title, c twoLinkCount FROM (
	SELECT r1.fromId, COUNT(*) c FROM Reference r1
	INNER JOIN (SELECT r2.id id2, r2.fromId fromId2, r2.toId toId2 FROM Reference r2) s1 ON r1.toId = s1.fromId2
	INNER JOIN (SELECT r3.id id3, r3.fromId fromId3, r3.toId toId3 FROM Reference r3) s2 ON s1.toId2 = s2.fromId3
	GROUP BY r1.fromId
) sLast
ORDER BY c DESC
LIMIT 1;

-- 17.
SELECT COUNT(*)
FROM (
	SELECT per.id actorPerId
	FROM Production pro
	INNER JOIN Role r ON pro.id = r.productionId
	INNER JOIN Person per ON r.personId = per.id
	WHERE r.roleName = 'actor'
	GROUP BY actorPerId)
AS actors
WHERE actors.actorPerId IN (
	SELECT per.id directorPerId
	FROM Production pro
	INNER JOIN Role r ON pro.id = r.productionId
	INNER JOIN Person per ON r.personId = per.id
	WHERE r.roleName = 'director');

-- 18.
SELECT gt1.genreName, gt2.genreName, amount
FROM (
	SELECT g1.genreTypeId g1Id, g2.genreTypeId g2Id, COUNT(*) amount
	FROM Production pro
	INNER JOIN Genre g1 ON pro.id = g1.productionId
	INNER JOIN Genre g2 ON pro.id = g2.productionId
	GROUP BY g1.genreTypeId, g2.genreTypeId
	) s1
INNER JOIN GenreType gt1 ON gt1.id = s1.g1Id
INNER JOIN GenreType gt2 ON gt2.id = s1.g2Id
WHERE gt1.genreName != gt2.genreName
GROUP BY gt1.genreName, gt2.genreName
ORDER BY amount DESC
LIMIT 1;