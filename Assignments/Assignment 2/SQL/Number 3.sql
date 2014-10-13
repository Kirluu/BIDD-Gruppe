SELECT * FROM (
	SELECT id FROM production
	WHERE id IN (
		SELECT id FROM production
		WHERE id IN (
			SELECT productionId FROM role
			WHERE personId IN (
				SELECT id FROM person 
				WHERE name="John Travolta" OR name="Uma Thurman")))) s1
WHERE NOT EXISTS (
	SELECT * FROM (
		SELECT id FROM production 
		WHERE id IN (
			SELECT r1.productionId FROM role r1
			INNER JOIN role r2 on r1.productionId = r2.productionId 
			WHERE r1.personId=(
				SELECT id FROM person 
				WHERE name="John Travolta") AND r2.personId=(
					SELECT id FROM person 
					WHERE name="Uma Thurman"))) s2 
	WHERE s1.id=s2.id);


SELECT id
FROM person
WHERE id IN (
	SELECT personId
	FROM role
	WHERE productionId=(
		SELECT id
		FROM production
		WHERE title="Pulp Fiction"));

