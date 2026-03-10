


-- Q2 Create tables
CREATE TABLE IF NOT EXISTS Stats (
    Abb TEXT PRIMARY KEY,
    Area REAL,
    Pop INTEGER
);

CREATE TABLE IF NOT EXISTS Names (
    Abb TEXT PRIMARY KEY,
    State TEXT
);

CREATE TABLE IF NOT EXISTS Capitals (
    State TEXT PRIMARY KEY,
    Capital TEXT,
    CapitalPop INTEGER
);

-- Q3 Verify structure
.schema Stats
.schema Names
.schema Capitals

PRAGMA table_info(Stats);
PRAGMA table_info(Names);
PRAGMA table_info(Capitals);

-- Q4 Display all tables
.tables
SELECT name FROM sqlite_master WHERE type='table';

-- Q5 Import data
.mode csv
.import Stats.csv Stats
.import Names.csv Names
.import Capitals.csv Capitals

-- Q6 Check first two rows
.mode column
.headers on

SELECT * FROM Stats LIMIT 2;
SELECT * FROM Names LIMIT 2;
SELECT * FROM Capitals LIMIT 2;

-- Q7 Top 5 states by population
SELECT Abb, Pop
FROM Stats
ORDER BY Pop DESC
LIMIT 5;

-- Q8 Smallest land area
SELECT Abb
FROM Stats
ORDER BY Area ASC
LIMIT 1;

-- Q9 Density below 50
SELECT COUNT(*)
FROM Stats
WHERE (Pop / Area) < 50;

-- Q10 Population between 1M and 2M
SELECT Abb
FROM Stats
WHERE Pop BETWEEN 1000000 AND 2000000;

-- Q11 Population density
SELECT Abb,
ROUND(Pop * 1.0 / Area, 2) AS Density
FROM Stats;

-- Q12 Abbreviation, name, capital
SELECT Names.Abb, Names.State, Capitals.Capital
FROM Names
JOIN Capitals
ON Names.State = Capitals.State;

-- Q13 Name, capital, capital population
SELECT Names.State, Capitals.Capital, Capitals.CapitalPop
FROM Names
JOIN Capitals
ON Names.State = Capitals.State;

-- Q14 Density >100 and capital pop >200k
SELECT Names.State
FROM Stats
JOIN Names ON Stats.Abb = Names.Abb
JOIN Capitals ON Names.State = Capitals.State
WHERE (Pop * 1.0 / Area) > 100
AND CapitalPop > 200000;

-- Q15 Capital pop greater than 3× average
SELECT State, Capital
FROM Capitals
WHERE CapitalPop > 3 * (SELECT AVG(CapitalPop) FROM Capitals);

-- Q16 Total land area
SELECT SUM(Area) AS TotalLandArea
FROM Stats;

-- Q17 Add Density column
ALTER TABLE Stats ADD COLUMN Density REAL;

UPDATE Stats
SET Density = Pop * 1.0 / Area;

-- Q18 Density <2 and capital pop >500k
SELECT Names.State
FROM Stats
JOIN Names ON Stats.Abb = Names.Abb
JOIN Capitals ON Names.State = Capitals.State
WHERE Density < 2
AND CapitalPop > 500000;

-- Q19 Pairs of states with density difference ≤0.3
SELECT s1.Abb, s2.Abb
FROM Stats s1
JOIN Stats s2
ON s1.Abb < s2.Abb
WHERE ABS(s1.Density - s2.Density) <= 0.3;

-- Q20 Union query
SELECT State
FROM Names
JOIN Stats ON Names.Abb = Stats.Abb
WHERE Pop > 20000000

UNION

SELECT State
FROM Names
JOIN Stats ON Names.Abb = Stats.Abb
WHERE Area > 300000;

-- Q21 Density categories
SELECT
CASE
WHEN Density < 50 THEN 'Low'
WHEN Density BETWEEN 50 AND 100 THEN 'Medium'
ELSE 'High'
END AS DensityRange,
SUM(Pop) AS TotPop,
ROUND(AVG(Area),2) AS AvgArea
FROM Stats
GROUP BY DensityRange;

-- Q22 Only categories with population >100M
SELECT
CASE
WHEN Density < 50 THEN 'Low'
WHEN Density BETWEEN 50 AND 100 THEN 'Medium'
ELSE 'High'
END AS DensityRange,
SUM(Pop) AS TotPop,
ROUND(AVG(Area),2) AS AvgArea
FROM Stats
GROUP BY DensityRange
HAVING SUM(Pop) > 100000000;
