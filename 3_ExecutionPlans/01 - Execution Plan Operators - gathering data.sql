-- Include Actual Execution Plan (Ctrl+M)

BEGIN TRANSACTION

	-- Copy data to new table (no PK, index, ...)
	SELECT * 
		INTO SalesOrderHeader_Heap
		FROM Sales.SalesOrderHeader

	-- TableScan
	SELECT SalesOrderID FROM SalesOrderHeader_Heap
		WHERE (SalesOrderID BETWEEN 60000 AND 65000)

ROLLBACK

-- Clustered Index Scan (+ suggested index)
SELECT PurchaseOrderNumber FROM Sales.SalesOrderHeader
	WHERE (ShipDate >= GETDATE())

-- Clustered Index Seek
SELECT SalesOrderID FROM Sales.SalesOrderHeader
	WHERE (SalesOrderID BETWEEN 60000 AND 65000)


-- Index Scan
SELECT SalesOrderID FROM Sales.SalesOrderHeader
	WHERE (SalesOrderID BETWEEN 60000 AND 165000)


-- Index Seek
SELECT SalesOrderID FROM Sales.SalesOrderHeader
	WHERE (CustomerID = 500)


-- Index Seek + Key Lookup
SELECT ShipDate FROM Sales.SalesOrderHeader
	WHERE (CustomerID = 500)




-- ==== If time permits / own experiments ===

-- OPTIONAL: RID Lookup
BEGIN TRANSACTION
	SELECT * 
		INTO SalesOrderHeader_Heap
		FROM Sales.SalesOrderHeader

	-- RID Lookup (lookup in Heapu without Clustered Index)
	CREATE INDEX ix ON SalesOrderHeader_Heap (ShipDate)
	SELECT * FROM SalesOrderHeader_Heap WHERE ShipDate = GETDATE()
ROLLBACK


-- OPTIONAL: Constant Scan
SELECT 1 WHERE 1 IN (1,2,3,4,5)