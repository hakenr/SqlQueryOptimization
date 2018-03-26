-- "Parameter sniffing"

DROP PROCEDURE SalesOrderHeader_Search
GO

-- Vyhled� objedn�vky odpov�daj�c� podm�nk�m vstupn�ho filtru.
-- Jednotliv� parametry odpov�daj� podm�nk�m filtru. Nem�-li se filtr uplatnit, parametr se nenastavuje (NULL).
CREATE PROCEDURE SalesOrderHeader_Search (
	@SalesOrderNumber nvarchar(25) = NULL,
	@OrderDateFrom date = NULL,
	@OrderDateTo date = NULL,
	@CustomerID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT SalesOrderID
		FROM Sales.SalesOrderHeader
		WHERE
			((@CustomerID IS NULL) OR (CustomerID = @CustomerID))
			AND ((@SalesOrderNumber IS NULL) OR (SalesOrderNumber = @SalesOrderNumber))
			AND ((@OrderDateFrom IS NULL) OR (OrderDate >=  @OrderDateFrom))
			AND ((@OrderDateTo IS NULL) OR (OrderDate < DATEADD(day, 1, @OrderDateTo)))
		-- OPTION (RECOMPILE)
END
GO

-- Show execution plan
DBCC FREEPROCCACHE
EXEC SalesOrderHeader_Search @OrderDateFrom = '20000131', @OrderDateTo = '20130523'
EXEC SalesOrderHeader_Search @CustomerID = 30052
GO

-- Obr�cen� po�ad�
DBCC FREEPROCCACHE
EXEC SalesOrderHeader_Search @CustomerID = 30052
EXEC SalesOrderHeader_Search @OrderDateFrom = '20000131', @OrderDateTo = '20130523'
GO

-- P��m� dotaz bez storky
DECLARE @CustomerID int = 30052
SELECT SalesOrderID FROM Sales.SalesOrderHeader WHERE (CustomerID = @CustomerID)

DECLARE @OrderDateFrom date ='20000131', @OrderDateTo date = '20130523'
SELECT SalesOrderID FROM Sales.SalesOrderHeader
	WHERE  (OrderDate >=  @OrderDateFrom) AND (OrderDate < DATEADD(day, 1, @OrderDateTo))

GO

