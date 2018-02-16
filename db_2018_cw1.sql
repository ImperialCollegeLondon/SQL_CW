
-- Q1 returns (name,father,mother)
SELECT child.name AS name , child.mother AS mother, child.father AS father
FROM person child
INNER JOIN person mother ON child.mother = mother.name
INNER JOIN person father ON child.father = father.name
WHERE child.dod < father.dod
AND   child.dod < mother.dod
ORDER BY child.name;

-- Q2 returns (name)
SELECT DISTINCT person.name
FROM person, prime_minister, monarch
WHERE person.name=prime_minister.name 
	OR person.name = monarch.name
	AND monarch.house IS NOT NULL
ORDER BY person.name
;

-- Q3 returns (name)
SELECT DISTINCT pred.name 
FROM monarch pred NATURAL JOIN person, monarch succ
WHERE pred.name <> succ.name 
	and succ.accession < dod
	and pred.accession < succ.accession;
;

-- Q4 returns (house,name,accession)
SELECT house,name,accession
FROM monarch
WHERE house IS NOT NULL
AND accession <= all(SELECT accession 
			FROM monarch AS first
			WHERE house = monarch.house)
ORDER BY accession
;

-- Q5 returns (first_name,popularity)
SELECT 	CASE WHEN person.name LIKE '% %'
		THEN SUBSTRING(person.name FROM 1 FOR POSITION(' ' IN person.name) -1) 
		ELSE person.name 
	END AS first_name, 
	COUNT( CASE WHEN person.name LIKE '% %'
			THEN SUBSTRING(person.name FROM 1 FOR POSITION(' ' IN person.name) -1)
        		ELSE person.name 
		END) AS popularity
FROM person

GROUP BY (first_name)
	HAVING COUNT( CASE 
			WHEN person.name LIKE '% %'THEN SUBSTRING(person.name FROM 1 FOR POSITION(' ' IN person.name) -1)
        		ELSE person.name 
		      END) > 1
ORDER BY popularity DESC, first_name ASC
;
-- Q6 returns (house,seventeenth,eighteenth,nineteenth,twentieth)
SELECT house, COUNT(CASE WHEN (accession>'1601-01-01' AND accession<'1700-12-31') THEN 'seventeenth'END) AS seventeenth,
	      COUNT(CASE WHEN (accession>'1701-01-01' AND accession<'1800-12-31') THEN 'eighteenth' END) AS eighteenth,
	      COUNT(CASE WHEN (accession>'1801-01-01' AND accession<'1900-12-31') THEN 'nineteenth' END) AS nineteenth,
	      COUNT(CASE WHEN (accession>'1901-01-01' AND accession<'2000-12-31') THEN 'twentieth'  END) AS twentieth 
FROM monarch
WHERE monarch.house IS NOT NULL
GROUP BY house   
ORDER BY house
; 


-- Q7 returns (father,child,born)
SELECT father, name AS child, rank() over (partition BY father ORDER BY dob desc) AS Born
FROM person
WHERE father IS NOT null
UNION
SELECT name AS father,
null AS child,
null AS born
FROM person
WHERE gender ='M'
AND name NOT IN (SELECT DISTINCT father
			FROM person
			WHERE father IS NOT null)
GROUP BY father, name
ORDER BY father, born
;
-- Q8 returns (monarch,prime_minister)

SELECT DISTINCT monarch.name as monarch, prime_minister.name AS prime_minister
FROM monarch LEFT JOIN prime_minister ON ( prime_minister.entry>monarch.accession
					AND prime_minister.entry < all( SELECT accession 
									FROM monarch AS omonarch
									WHERE omonarch.accession > monarch.accession)
									OR (prime_minister.entry < monarch.accession 
									and monarch.accession < all ( SELECT entry FROM prime_minister AS opm
													WHERE opm.entry > prime_minister.entry )))
WHERE prime_minister.name IS NOT NULL; 	  
