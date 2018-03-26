/*************************************************************************************/
/* Pøíprava situace																	 */
/*************************************************************************************/

USE GoranSample
DROP INDEX TimesheetItem_SchvalenoKdy ON TimesheetItem

SET STATISTICS TIME ON
SET STATISTICS IO ON
-- Execution plans
GO

/*************************************************************************************/
/* Co bude rychlejší?																 */
/*************************************************************************************/

-- Jeden prùchod - "CASE fígl"
DBCC DROPCLEANBUFFERS 
SELECT
		PracovnikID,
		SUM(CASE WHEN SchvalenoKdy IS NOT NULL THEN 1 ELSE 0 END) AS PocetSchvalenychZaznamu,
		SUM(CASE WHEN SchvalenoKdy IS NULL THEN 1 ELSE 0 END) AS PocetNeschvalenychZaznamu,
		SUM(CASE WHEN SchvalenoKdy IS NOT NULL THEN PocetHodin ELSE 0 END) AS PocetSchvalenychHodin,
		SUM(CASE WHEN SchvalenoKdy IS NULL THEN PocetHodin ELSE 0 END) AS PocetNeschvalenychHodin,
		SUM(OsobniNaklady) AS OsobniNakladyCelkem
	FROM TimesheetItem
	GROUP BY PracovnikID
	ORDER BY PracovnikID
GO

-- Agregované statistiky timesheetù po pracovnících - SUBDOTAZY
DBCC DROPCLEANBUFFERS 
SELECT
	PracovnikID,
	(SELECT COUNT(*) FROM TimesheetItem ti
		WHERE (SchvalenoKdy IS NOT NULL) AND (ti.PracovnikID = Pracovnik.PracovnikID)
	) AS PocetSchvalenychZaznamu,
	(SELECT COUNT(*) FROM TimesheetItem ti
		WHERE (SchvalenoKdy IS NULL) AND (ti.PracovnikID = Pracovnik.PracovnikID)
	) AS PocetNeschvalenychZaznamu,
	(SELECT SUM(PocetHodin) FROM TimesheetItem ti
		WHERE (SchvalenoKdy IS NOT NULL) AND (ti.PracovnikID = Pracovnik.PracovnikID)
	) AS PocetSchvalenychHodin,
	(SELECT SUM(PocetHodin) FROM TimesheetItem ti
		WHERE (SchvalenoKdy IS NULL) AND (ti.PracovnikID = Pracovnik.PracovnikID)
	) AS PocetNeschvalenychHodin,
	(SELECT SUM(OsobniNaklady) FROM TimesheetItem ti
		WHERE (ti.PracovnikID = Pracovnik.PracovnikID)
	) AS OsobniNakladyCelkem
	FROM Pracovnik
	ORDER BY PracovnikID
GO

/*************************************************************************************/
/* Co když pøidáme index?															 */
/*************************************************************************************/
CREATE INDEX TimesheetItem_SchvalenoKdy ON TimesheetItem (SchvalenoKdy) INCLUDE (PracovnikID, PocetHodin)	
GO
	

