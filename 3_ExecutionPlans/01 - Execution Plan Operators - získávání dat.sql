USE AdventureWorks2012
-- Zapnout Include Actual Execution Plan (Ctrl+M)

BEGIN TRANSACTION

	-- Zkopírujeme data do nové tabulky, ta nemá žádné indexy, ani primární klíè
	SELECT * 
		INTO SalesOrderHeader_BezPrimarnihoKlice
		FROM Sales.SalesOrderHeader

	-- TableScan
	SELECT SalesOrderID FROM SalesOrderHeader_BezPrimarnihoKlice
		WHERE (SalesOrderID BETWEEN 60000 AND 65000)

ROLLBACK

-- Clustered Index Scan (+ doporuèený index)
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




-- ==== Pokud èas dovolí / pro vlastní pokusy ===

-- OPTIONAL: RID Lookup
BEGIN TRANSACTION
	SELECT * 
		INTO SalesOrderHeader_BezPrimarnihoKlice
		FROM Sales.SalesOrderHeader

	-- RID Lookup (dohledávání v Heapu bez Clustered Indexu)
	CREATE INDEX ix ON SalesOrderHeader_BezPrimarnihoKlice (ShipDate)
	SELECT * FROM SalesOrderHeader_BezPrimarnihoKlice WHERE ShipDate = GETDATE()
ROLLBACK


-- OPTIONAL: Constant Scan (uvidíme pozdìji, viz vyhledávání dle data)
SELECT 1 WHERE 1 IN (1,2,3,4,5)