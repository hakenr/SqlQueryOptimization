USE AdventureWorks2012
-- Zapnout Include Actual Execution Plan (Ctrl+M)


-- Merge Join
SELECT ProductID, OrderQty, ShipDate FROM Sales.SalesOrderDetail
	INNER JOIN Sales.SalesOrderHeader ON (SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID)


-- Hash Match
SELECT SalesOrderID, ProductNumber FROM Sales.SalesOrderDetail
	INNER JOIN Production.Product ON (SalesOrderDetail.UnitPrice = Product.ListPrice)


-- Nested Loops, Key Lookup
SELECT ProductID, OrderQty, ShipDate FROM Sales.SalesOrderDetail
	INNER JOIN Sales.SalesOrderHeader ON (SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID)
	WHERE (SalesOrderHeader.CustomerID IN (29825, 29672, 29974))
