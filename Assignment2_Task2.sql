
-- Q2
CREATE TABLE IF NOT EXISTS Orders (
    RowID INTEGER,
    OrderID TEXT,
    OrderDate TEXT,
    ShipDate TEXT,
    ShipMode TEXT,
    CustomerID TEXT,
    CustomerName TEXT,
    Segment TEXT,
    Country TEXT,
    City TEXT,
    State TEXT,
    PostalCode TEXT,
    Region TEXT,
    ProductID TEXT,
    Category TEXT,
    SubCategory TEXT,
    ProductName TEXT,
    Sales REAL,
    Quantity INTEGER,
    Discount REAL,
    Profit REAL
);

CREATE TABLE IF NOT EXISTS People (
    Person TEXT,
    Region TEXT
);

CREATE TABLE IF NOT EXISTS Returns (
    Returned TEXT,
    OrderID TEXT
);

-- Q3
.mode csv
.import Orders.csv Orders
.import People.csv People
.import Returns.csv Returns

-- Q4
.mode column
.headers on

-- check import
SELECT * FROM Orders LIMIT 3;
SELECT * FROM People LIMIT 3;
SELECT * FROM Returns LIMIT 3;

-- Q5
SELECT Country,
       COUNT(*) AS "Number of Sales"
FROM Orders
GROUP BY Country
ORDER BY "Number of Sales" DESC;

-- Q6
SELECT Country,
       COUNT(*) AS "Number of Sales"
FROM Orders
WHERE Country LIKE '%X%'
   OR Country LIKE '%Y%'
   OR Country LIKE '%Z%'
GROUP BY Country
ORDER BY "Number of Sales" DESC;

-- Q7
SELECT Country,
       ROUND(SUM(Profit), 2) AS "Total Profit",
       ROUND(SUM(Profit) * 1.0 / COUNT(*), 2) AS "Profit per Sale"
FROM Orders
WHERE Country LIKE '%X%'
   OR Country LIKE '%Y%'
   OR Country LIKE '%Z%'
GROUP BY Country
ORDER BY "Profit per Sale" DESC;

-- Q8
SELECT Country,
       ROUND(SUM(Profit), 2) AS "Total Profit",
       ROUND(SUM(Profit) * 1.0 / COUNT(*), 2) AS "Profit per Sale"
FROM Orders
WHERE Country LIKE '%X%'
   OR Country LIKE '%Y%'
   OR Country LIKE '%Z%'
GROUP BY Country
HAVING SUM(Profit) < 0
    OR (SUM(Profit) * 1.0 / COUNT(*)) < 0;

-- Q9
SELECT Country,
       SUM(Quantity) AS "Total Units Sold",
       ROUND(SUM(Sales), 2) AS "Total Sales",
       ROUND(SUM(Sales) * 1.0 / SUM(Quantity), 2) AS "Sales per Unit",
       ROUND(SUM(Profit), 2) AS "Total Profit",
       ROUND(SUM(Profit) * 1.0 / SUM(Quantity), 2) AS "Profit per Unit"
FROM Orders
WHERE Country IN ('United States', 'France', 'Mexico')
GROUP BY Country;

-- Q10
SELECT Country,
       strftime('%Y', OrderDate) AS Year,
       SUM(Quantity) AS "Total Units Sold",
       ROUND(SUM(Sales), 2) AS "Total Sales",
       ROUND(SUM(Sales) * 1.0 / SUM(Quantity), 2) AS "Sales per Unit",
       ROUND(SUM(Profit), 2) AS "Total Profit",
       ROUND(SUM(Profit) * 1.0 / SUM(Quantity), 2) AS "Profit per Unit"
FROM Orders
WHERE Country IN ('United States', 'France', 'Mexico')
GROUP BY Country, Year
ORDER BY Country, Year;

-- Q11
SELECT Country,
       strftime('%Y', OrderDate) AS Year,
       CAST(strftime('%m', OrderDate) AS INTEGER) AS Month,
       SUM(Quantity) AS "Total Units Sold",
       ROUND(SUM(Sales), 2) AS "Total Sales",
       ROUND(SUM(Sales) * 1.0 / SUM(Quantity), 2) AS "Sales per Unit",
       ROUND(SUM(Profit), 2) AS "Total Profit",
       ROUND(SUM(Profit) * 1.0 / SUM(Quantity), 2) AS "Profit per Unit"
FROM Orders
WHERE Country IN ('United States', 'France', 'Mexico')
GROUP BY Country, Year, Month
ORDER BY Country, Year, Month;

-- Q12
SELECT Region,
       SUM(Quantity) AS "Total Units Sold",
       ROUND(SUM(Sales), 2) AS "Total Sales",
       ROUND(SUM(Sales) * 1.0 / SUM(Quantity), 2) AS "Sales per Unit",
       ROUND(SUM(Profit), 2) AS "Total Profit",
       ROUND(SUM(Profit) * 1.0 / SUM(Quantity), 2) AS "Profit per Unit"
FROM Orders
GROUP BY Region;

-- Q13
SELECT Region,
       strftime('%Y', OrderDate) AS Year,
       SUM(Quantity) AS "Total Units Sold",
       ROUND(SUM(Sales), 2) AS "Total Sales",
       ROUND(SUM(Sales) * 1.0 / SUM(Quantity), 2) AS "Sales per Unit",
       ROUND(SUM(Profit), 2) AS "Total Profit",
       ROUND(SUM(Profit) * 1.0 / SUM(Quantity), 2) AS "Profit per Unit"
FROM Orders
GROUP BY Region, Year
ORDER BY Region, Year;

-- Q14
SELECT Region,
       SUM(Quantity) AS "Total Units Sold",
       ROUND(SUM(Sales), 2) AS "Total Sales",
       ROUND(SUM(Sales) * 1.0 / SUM(Quantity), 2) AS "Sales per Unit",
       ROUND(SUM(Profit), 2) AS "Total Profit",
       ROUND(SUM(Profit) * 1.0 / SUM(Quantity), 2) AS "Profit per Unit"
FROM Orders
GROUP BY Region;

-- Q15
SELECT Region,
       strftime('%Y', OrderDate) AS Year,
       SUM(Quantity) AS "Total Units Sold",
       ROUND(SUM(Sales), 2) AS "Total Sales",
       ROUND(SUM(Sales) * 1.0 / SUM(Quantity), 2) AS "Sales per Unit",
       ROUND(SUM(Profit), 2) AS "Total Profit",
       ROUND(SUM(Profit) * 1.0 / SUM(Quantity), 2) AS "Profit per Unit"
FROM Orders
GROUP BY Region, Year
ORDER BY Region, Year;

-- Q16
SELECT o.Region,
       p.Person,
       strftime('%Y', o.OrderDate) AS Year,
       SUM(o.Quantity) AS "Total Units Sold",
       ROUND(SUM(o.Sales), 2) AS "Total Sales",
       ROUND(SUM(o.Sales) * 1.0 / SUM(o.Quantity), 2) AS "Sales per Unit",
       ROUND(SUM(o.Profit), 2) AS "Total Profit",
       ROUND(SUM(o.Profit) * 1.0 / SUM(o.Quantity), 2) AS "Profit per Unit"
FROM Orders o
JOIN People p
ON o.Region = p.Region
GROUP BY o.Region, p.Person, Year
ORDER BY o.Region, p.Person, Year;

-- Q17
.mode csv
.output LostProfitByRegion.csv

SELECT o.Region,
       p.Person,
       ROUND(SUM(o.Profit), 2) AS "Lost Total Profit"
FROM Orders o
JOIN Returns r
  ON o.OrderID = r.OrderID
JOIN People p
  ON o.Region = p.Region
GROUP BY o.Region, p.Person
ORDER BY "Lost Total Profit" DESC;

.output stdout
.mode column
.headers on
