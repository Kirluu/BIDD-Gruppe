-- 1.
SELECT COUNT(*)
FROM Production
WHERE language='Danish';

-- 2.
-- SELECT year
-- FROM Production, (
-- 	SELECT COUNT(*)
-- 	FROM Rating
-- 	WHERE productionId = Production.id) d
-- GROUP BY year;

-- 2.1
SELECT year, COUNT(*)
FROM Production
INNER JOIN Rating ON id = productionId
GROUP BY year;

-- 3.2
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
						  WHERE per1.name='John Travolta' AND per2.name='Uma Thurman');

-- 3.3
SELECT id AS productionId FROM Production
INNER JOIN (
	SELECT * FROM Role R1
	LEFT JOIN Role R2 ON R1.personId = (SELECT id FROM Person WHERE name = 'John Travolta')
	UNION
	SELECT * FROM Role R1
	RIGHT JOIN Role R2 ON R1.personId = (SELECT id FROM Person WHERE name = 'Uma Thurman')
) d

SELECT DISTINCT * FROM (
	SELECT id AS pId, title FROM Production pro1
	INNER JOIN (SELECT personId AS rPId, productionId AS rProId FROM Role r1) da ON pId = r1.productionId
	INNER JOIN Person per1 ON r1.personId = per1.id
	WHERE per1.name = 'John Travolta'
) d1
WHERE NOT EXISTS (
	SELECT * FROM (
		SELECT * FROM Production pro2
		INNER JOIN Role r2 ON pro2.id = r2.productionId
		INNER JOIN Person per2 ON r2.personId = per2.id
		WHERE per2.name = 'Uma Thurman'
	) d2
	WHERE d1.id = d2.id
);

SELECT E.id FROM Production E WHERE exists (
  SELECT 1 FROM Person M WHERE E.id = M.ensembleid
  AND M.instrument IN ('John Travolta', 'Uma Thurman')
) AND not (
  exists (
    SELECT 1 FROM Person M WHERE E.id = M.ensembleid
    AND M.instrument = 'John Travolta'
  ) AND exists (
    SELECT 1 FROM Person M WHERE E.id = M.ensembleid
    AND M.instrument = 'Uma Thurman'
  )
);

-- 4.
SELECT COUNT(*)
FROM Person p
INNER JOIN Role r ON p.id = r.personId
WHERE p.name LIKE 'C%';

-- 5.
SELECT per.name, per.birthdate
FROM (Person per
INNER JOIN Role r ON r.personId = per.id
INNER JOIN Production pro ON pro.id = r.productionId)
WHERE pro.name='Pulp Fiction'
ORDER BY ascending;

-- 6.
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

-- 7.
SELECT userId, COUNT(*) c
FROM Rating
GROUP BY userId HAVING c <= 10;

-- 8.
SELECT *
FROM Production
WHERE year < 2000 AND year >= 1990 ORDER BY imdbRank desc LIMIT 5;

-- 9.
SELECT *
FROM Production, (SELECT COUNT(*) FROM Rating GROUP BY productionId) votesPerProd
WHERE id = (SELECT productionId, AVG(rating) avg
			FROM Rating
			GROUP BY productionId ORDER BY avg desc LIMIT 5).productionId
AND 