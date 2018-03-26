/*************************************************************************************/
/* PROBL�M:	M�me sloupec datetime, kde je i slo�ka �asu.							 */
/*			Chceme z�skat z�znamy z ur�it�ho dne.									 */
/*************************************************************************************/


/*************************************************************************************/
/* Vstupn� data, p��prava situace													 */
/*************************************************************************************/
USE GoranSample

GO

-- Vzorov� data
-- Exituje index na sloupci Created
SELECT COUNT(*) FROM Times
SELECT TOP 100 * FROM Times
GO

-- M��en� rychlosti - statistika, zapnout execution plans
SET STATISTICS TIME ON
GO


/*************************************************************************************/
/* VAR. 1 - CONVERT na FLOAT se zaokrouhlen�m na dny (verze SQL bez omezen�)		 */
/*************************************************************************************/

DBCC DROPCLEANBUFFERS 
DECLARE @DateFilter smalldatetime
SET @DateFilter = '20090305'

SELECT Created FROM Times
	WHERE FLOOR(CONVERT(float, Created)) = FLOOR(CONVERT(float, @DateFilter))
GO


/*************************************************************************************/
/* VAR. 2 - CONVERT na VARCHAR v podob� bez �asu (verze SQL bez omezen�)			 */
/*************************************************************************************/

DBCC DROPCLEANBUFFERS 
DECLARE @DateFilter smalldatetime
SET @DateFilter = '20090305'

SELECT Created FROM Times
	WHERE CONVERT(varchar(10), Created, 101) = CONVERT(varchar(10), @DateFilter, 101)
GO


/*************************************************************************************/
/* VAR. 3 - Porovn�n� na DATEPART a YEAR							 				 */
/*************************************************************************************/

DBCC DROPCLEANBUFFERS
DECLARE @DateFilter date
SET @DateFilter = '20090305'

SELECT Created FROM Times
	WHERE 
		(YEAR(Created) = YEAR(@DateFilter))
		AND (DATEPART(dayofyear, Created) = DATEPART(dayofyear, @DateFilter))
GO



/*************************************************************************************/
/* VAR. 4 - DATEADD, DATEDIFF														 */
/*************************************************************************************/

DBCC DROPCLEANBUFFERS 
DECLARE @DateFilter smalldatetime
SET @DateFilter = '20090305'

SELECT Created FROM Times
	WHERE DATEADD(dd,DATEDIFF(dd, 0, Created), 0) = @DateFilter
GO


/*************************************************************************************/
/* VAR. 5 - CONVERT na DATE (SQL2005+)								 				 */
/*************************************************************************************/

DBCC DROPCLEANBUFFERS
DECLARE @DateFilter date
SET @DateFilter = '20090305'

SELECT Created FROM Times
	WHERE CONVERT(date, Created) = @DateFilter
GO



/*************************************************************************************/
/* VAR. 6 - Range od 0:00 (incl.) do 0:00 n�sleduj�c�ho dne (excl.) 				 */
/*************************************************************************************/

DBCC DROPCLEANBUFFERS 
DECLARE @DateFilter smalldatetime
SET @DateFilter = '20090305'

SELECT Created FROM Times
	WHERE
		(Created >= @DateFilter)
		AND (Created < DATEADD(day, 1, @DateFilter))
GO
