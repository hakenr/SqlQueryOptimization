USE AdventureWorks2012
-- Zapnout Include Actual Execution Plan (Ctrl+M)

-- Sort
SELECT TOP 10 SalesOrderID, SubTotal FROM Sales.SalesOrderHeader ORDER BY SubTotal


-- OPTIONAL: Compute Scalar
SELECT (SubTotal + TaxAmt) AS Total FROM Sales.SalesOrderHeader
	WHERE SalesOrderID = 100


-- OPTIONAL: Concatenation
SELECT ModifiedDate FROM Sales.SalesOrderHeader
UNION ALL
SELECT ModifiedDate FROM Sales.Customer


-- OPTIONAL: Merge Interval
DECLARE
	@a1 int = 10,
	@a2 int = 100,
	@b1 int = 1000,
	@b2 int = 10000
SELECT SUM(SubTotal) FROM Sales.SalesOrderHeader
	WHERE SalesOrderID BETWEEN @a1 AND @a2
		OR (SalesOrderID BETWEEN @b1 AND @b2)