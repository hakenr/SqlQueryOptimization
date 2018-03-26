USE AdventureWorks2012
GO

/*************************************************************************************/
/* Ukázky																		 */
/*************************************************************************************/
SELECT * FROM Sales.SalesPerson ORDER BY TerritoryID -- NULL je pøi øazení menší než hodnota

SELECT COUNT(*) FROM Sales.SalesPerson
SELECT COUNT(*) FROM Sales.SalesPerson WHERE SalesQuota < 300000
SELECT COUNT(*) FROM Sales.SalesPerson WHERE SalesQuota >= 300000

SELECT * FROM Sales.SalesPerson WHERE TerritoryID <> 1

SELECT * FROM Sales.SalesPerson WHERE TerritoryID NOT IN (1, 2)
SELECT * FROM Sales.SalesPerson WHERE TerritoryID NOT IN (1, 2, NULL)
SELECT * FROM Sales.SalesPerson WHERE TerritoryID IN (1, 2, NULL)


/*************************************************************************************/
/* Chování NULL																		 */
/*************************************************************************************/

IF (NULL = NULL)
	PRINT 'Splnìno'
ELSE
	PRINT 'Nesplnìno'
GO

IF (NULL <> NULL)
	PRINT 'Splnìno'
ELSE
	PRINT 'Nesplnìno'
GO


IF (NULL != 10)
	PRINT 'Splnìno'
ELSE
	PRINT 'Nesplnìno'
GO

IF (NULL = 10)
	PRINT 'Splnìno'
ELSE
	PRINT 'Nesplnìno'
GO

IF (NULL IS NULL)
	PRINT 'Splnìno'
ELSE
	PRINT 'Nesplnìno'
GO


/*************************************************************************************/
/* Pøepínaè - SET ANSI_NULLS ON/OFF													 */
/*************************************************************************************/

-- Výchozí nastavení ON
SET ANSI_NULLS ON
SELECT * FROM Sales.SalesPerson WHERE TerritoryID = NULL
GO

-- Obskurní pøepínaè
SET ANSI_NULLS OFF
SELECT * FROM Sales.SalesPerson WHERE TerritoryID = NULL
SELECT * FROM Sales.SalesPerson WHERE TerritoryID NOT IN (1,2,3,4)
SET ANSI_NULLS ON
GO

/*
	MSDN: SET ANSI_NULLS (Transact-SQL)
	"IMPORTANT:In a future version of SQL Server, ANSI_NULLS will
	always be ON and any applications that explicitly set the option
	to OFF will generate an error.
	Avoid using this feature in new development work, and plan
	to modify applications that currently use this feature."
	http://msdn.microsoft.com/en-us/library/ms188048.aspx
*/