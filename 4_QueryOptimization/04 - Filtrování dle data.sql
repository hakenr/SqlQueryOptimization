/*************************************************************************************/
/* PROBLÉM:	Máme sloupec datetime, kde je i složka èasu.							 */
/*			Chceme získat záznamy z urèitého dne.									 */
/*************************************************************************************/


/*************************************************************************************/
/* Vstupní data, pøíprava situace													 */
/*************************************************************************************/
USE GoranSample

GO

-- Vzorová data
-- Exituje index na sloupci Created
SELECT COUNT(*) FROM Times
SELECT TOP 100 * FROM Times
GO

-- Mìøení rychlosti - statistika, zapnout execution plans
SET STATISTICS TIME ON
GO


/*************************************************************************************/
/* VAR. 1 - CONVERT na FLOAT se zaokrouhlením na dny (verze SQL bez omezení)		 */
/*************************************************************************************/

DBCC DROPCLEANBUFFERS 
DECLARE @DateFilter smalldatetime
SET @DateFilter = '20090305'

SELECT Created FROM Times
	WHERE FLOOR(CONVERT(float, Created)) = FLOOR(CONVERT(float, @DateFilter))
GO


/*************************************************************************************/
/* VAR. 2 - CONVERT na VARCHAR v podobì bez èasu (verze SQL bez omezení)			 */
/*************************************************************************************/

DBCC DROPCLEANBUFFERS 
DECLARE @DateFilter smalldatetime
SET @DateFilter = '20090305'

SELECT Created FROM Times
	WHERE CONVERT(varchar(10), Created, 101) = CONVERT(varchar(10), @DateFilter, 101)
GO


/*************************************************************************************/
/* VAR. 3 - Porovnání na DATEPART a YEAR							 				 */
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
/* VAR. 6 - Range od 0:00 (incl.) do 0:00 následujícího dne (excl.) 				 */
/*************************************************************************************/

DBCC DROPCLEANBUFFERS 
DECLARE @DateFilter smalldatetime
SET @DateFilter = '20090305'

SELECT Created FROM Times
	WHERE
		(Created >= @DateFilter)
		AND (Created < DATEADD(day, 1, @DateFilter))
GO
