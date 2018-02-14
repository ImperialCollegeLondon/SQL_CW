
-- Q1 returns (name,father,mother)
SELECT child.name AS name , child.mother AS mother, child.father AS father
FROM person child
inner join person mother on child.mother = mother.name
inner join person father on child.father = father.name
WHERE child.dod < father.dod
AND   child.dod < mother.dod
ORDER BY child.name;

-- Q2 returns (name)
SELECT DISTINCT person.name
FROM person, prime_minister, monarch
WHERE person.name=prime_minister.name
OR person.name = monarch.name
ORDER BY person.name
;

-- Q3 returns (name)
SELECT person.name
FROM person, monarch
WHERE person.dod	
;

-- Q4 returns (house,name,accession)

;

-- Q5 returns (first_name,popularity)

;

-- Q6 returns (house,seventeenth,eighteenth,nineteenth,twentieth)

; 

-- Q7 returns (father,child,born)

;

-- Q8 returns (monarch,prime_minister)

;

