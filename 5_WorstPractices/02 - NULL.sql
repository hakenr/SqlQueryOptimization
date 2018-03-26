USE AdventureWorks2012
GO

/*************************************************************************************/
/* Uk�zky																		 */
/*************************************************************************************/
SELECT * FROM Sales.SalesPerson ORDER BY TerritoryID -- NULL je p�i �azen� men�� ne� hodnota

SELECT COUNT(*) FROM Sales.SalesPerson
SELECT COUNT(*) FROM Sales.SalesPerson WHERE SalesQuota < 300000
SELECT COUNT(*) FROM Sales.SalesPerson WHERE SalesQuota >= 300000

SELECT * FROM Sales.SalesPerson WHERE TerritoryID <> 1

SELECT * FROM Sales.SalesPerson WHERE TerritoryID NOT IN (1, 2)
SELECT * FROM Sales.SalesPerson WHERE TerritoryID NOT IN (1, 2, NULL)
SELECT * FROM Sales.SalesPerson WHERE TerritoryID IN (1, 2, NULL)


/*************************************************************************************/
/* Chov�n� NULL																		 */
/*************************************************************************************/

IF (NULL = NULL)
	PRINT 'Spln�no'
ELSE
	PRINT 'Nespln�no'
GO

IF (NULL <> NULL)
	PRINT 'Spln�no'
ELSE
	PRINT 'Nespln�no'
GO


IF (NULL != 10)
	PRINT 'Spln�no'
ELSE
	PRINT 'Nespln�no'
GO

IF (NULL = 10)
	PRINT 'Spln�no'
ELSE
	PRINT 'Nespln�no'
GO

IF (NULL IS NULL)
	PRINT 'Spln�no'
ELSE
	PRINT 'Nespln�no'
GO


/*************************************************************************************/
/* P�ep�na� - SET ANSI_NULLS ON/OFF													 */
/*************************************************************************************/

-- V�choz� nastaven� ON
SET ANSI_NULLS ON
SELECT * FROM Sales.SalesPerson WHERE TerritoryID = NULL
GO

-- Obskurn� p�ep�na�
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