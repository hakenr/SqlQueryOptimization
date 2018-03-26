USE AdventureWorks2012
-- Zapnout Include Actual Execution Plan (Ctrl+M)

-- Stream Aggregate (vy�aduje vstup se�azen� po skupin�ch)
SELECT MAX(ShipDate) FROM Sales.SalesOrderHeader


-- Top
SELECT MAX(SalesOrderID) FROM Sales.SalesOrderHeader
SELECT TOP 1 SalesOrderID FROM Sales.SalesOrderHeader ORDER BY SalesOrderID DESC


-- BTW: COUNT - jak� je rozd�l?
SELECT COUNT(*) FROM Sales.SalesOrderHeader
SELECT COUNT(PurchaseOrderNumber) FROM Sales.SalesOrderHeader


-- Hash Match (Aggregate)
SELECT SUM(SubTotal) FROM Sales.SalesOrderHeader
	GROUP BY CustomerID


-- Parallelism
SELECT COUNT(*) FROM GoranSample.dbo.Times -- (114M z�znam�)