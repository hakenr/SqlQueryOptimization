/*************************************************************************************/
-- Najdi pracovn�ky, kte�� maj� schv�len� alespo� jeden z�znam pracovn�ch v�kaz�
-- Kter� podoba dotazu bude nejrychlej��?
/*************************************************************************************/

/*************************************************************************************/
/* P��prava situace, zdrojov� data													 */
/*************************************************************************************/
USE GoranSample

SET STATISTICS TIME ON
SET STATISTICS IO ON
-- Execution plans

-- Zdrojov� data
SELECT COUNT(*) FROM TimesheetItem
SELECT TOP 10 * FROM TimesheetItem
SELECT COUNT(*) FROM Pracovnik
SELECT TOP 10 PracovnikID, KrestniJmeno FROM Pracovnik


/***************************************************************************************/
/* V�echno sJOINuj a zafiltruj. Jsou tam duplicity? Zatracen� JOIN, pom��e DISTINCT... */
/***************************************************************************************/
DBCC DROPCLEANBUFFERS 
SELECT DISTINCT Pracovnik.PracovnikID, Pracovnik.KrestniJmeno
	FROM Pracovnik
	INNER JOIN TimesheetItem
		ON (TimesheetItem.PracovnikID = Pracovnik.PracovnikID)
	WHERE
		(TimesheetItem.SchvalenoKdy IS NOT NULL)

/***************************************************************************************/
/* Najdi schv�len� z�znamy a vezmi pracovn�ky na nich. Je pracovn�k mezi nimi?		   */
/***************************************************************************************/
DBCC DROPCLEANBUFFERS 
SELECT Pracovnik.PracovnikID, Pracovnik.KrestniJmeno FROM Pracovnik
	WHERE PracovnikID IN (
		SELECT PracovnikID FROM TimesheetItem
			WHERE TimesheetItem.SchvalenoKdy IS NOT NULL)

/***************************************************************************************/
/* Najdi schv�len� a seskup je podle pracovn�ka. K pracovn�kovi dohledej jm�no.		   */
/***************************************************************************************/
DBCC DROPCLEANBUFFERS
SELECT Pracovnik.PracovnikID, Pracovnik.KrestniJmeno FROM Pracovnik
	WHERE PracovnikID IN (
		SELECT PracovnikID FROM TimesheetItem
			WHERE TimesheetItem.SchvalenoKdy IS NOT NULL
			GROUP BY PracovnikID)			