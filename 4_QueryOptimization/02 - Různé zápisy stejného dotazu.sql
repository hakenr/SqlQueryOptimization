/*************************************************************************************/
-- Najdi pracovníky, kteøí mají schválený alespoò jeden záznam pracovních výkazù
-- Která podoba dotazu bude nejrychlejší?
/*************************************************************************************/

/*************************************************************************************/
/* Pøíprava situace, zdrojová data													 */
/*************************************************************************************/
USE GoranSample

SET STATISTICS TIME ON
SET STATISTICS IO ON
-- Execution plans

-- Zdrojová data
SELECT COUNT(*) FROM TimesheetItem
SELECT TOP 10 * FROM TimesheetItem
SELECT COUNT(*) FROM Pracovnik
SELECT TOP 10 PracovnikID, KrestniJmeno FROM Pracovnik


/***************************************************************************************/
/* Všechno sJOINuj a zafiltruj. Jsou tam duplicity? Zatracený JOIN, pomùže DISTINCT... */
/***************************************************************************************/
DBCC DROPCLEANBUFFERS 
SELECT DISTINCT Pracovnik.PracovnikID, Pracovnik.KrestniJmeno
	FROM Pracovnik
	INNER JOIN TimesheetItem
		ON (TimesheetItem.PracovnikID = Pracovnik.PracovnikID)
	WHERE
		(TimesheetItem.SchvalenoKdy IS NOT NULL)

/***************************************************************************************/
/* Najdi schválené záznamy a vezmi pracovníky na nich. Je pracovník mezi nimi?		   */
/***************************************************************************************/
DBCC DROPCLEANBUFFERS 
SELECT Pracovnik.PracovnikID, Pracovnik.KrestniJmeno FROM Pracovnik
	WHERE PracovnikID IN (
		SELECT PracovnikID FROM TimesheetItem
			WHERE TimesheetItem.SchvalenoKdy IS NOT NULL)

/***************************************************************************************/
/* Najdi schválené a seskup je podle pracovníka. K pracovníkovi dohledej jméno.		   */
/***************************************************************************************/
DBCC DROPCLEANBUFFERS
SELECT Pracovnik.PracovnikID, Pracovnik.KrestniJmeno FROM Pracovnik
	WHERE PracovnikID IN (
		SELECT PracovnikID FROM TimesheetItem
			WHERE TimesheetItem.SchvalenoKdy IS NOT NULL
			GROUP BY PracovnikID)			