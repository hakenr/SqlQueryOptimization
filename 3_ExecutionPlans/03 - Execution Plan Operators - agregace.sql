USE AdventureWorks2012
-- Zapnout Include Actual Execution Plan (Ctrl+M)

-- Stream Aggregate (vyžaduje vstup seøazený po skupinách)
SELECT MAX(ShipDate) FROM Sales.SalesOrderHeader


-- Top
SELECT MAX(SalesOrderID) FROM Sales.SalesOrderHeader
SELECT TOP 1 SalesOrderID FROM Sales.SalesOrderHeader ORDER BY SalesOrderID DESC


-- BTW: COUNT - jaký je rozdíl?
SELECT COUNT(*) FROM Sales.SalesOrderHeader
SELECT COUNT(PurchaseOrderNumber) FROM Sales.SalesOrderHeader


-- Hash Match (Aggregate)
SELECT SUM(SubTotal) FROM Sales.SalesOrderHeader
	GROUP BY CustomerID


-- Parallelism
SELECT COUNT(*) FROM GoranSample.dbo.Times -- (114M záznamù)