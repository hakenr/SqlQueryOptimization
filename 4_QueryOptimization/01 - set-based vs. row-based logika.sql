/*************************************************************************************/
/* Pøíprava situace																	 */
/*************************************************************************************/

USE GoranSample
DROP FUNCTION dbo.GetPocetSchvalenychHodinPracovnika
GO

SET STATISTICS TIME ON
SET STATISTICS IO ON
-- Execution plans

/*************************************************************************************/
/* Øádková funkce																	 */
/*************************************************************************************/

-- Najdi pracovníky, kteøí mají 100 a více schválených hodin
-- Funkce pro zjištìní poètu schválených hodin pracovníka
CREATE FUNCTION dbo.GetPocetSchvalenychHodinPracovnika
	(@PracovnikID int)
RETURNS int
AS
BEGIN
	DECLARE @Result int
	SELECT @Result = SUM(PocetHodin)
				FROM TimesheetItem
				WHERE 
					(TimesheetItem.SchvalenoKdy IS NOT NULL)
					AND (TimesheetItem.PracovnikID = @PracovnikID)
	RETURN @Result
END
GO

-- Podmínku vyhodnocujeme pro každého pracovníka (row-based function)
DBCC DROPCLEANBUFFERS 
SELECT PracovnikID, KrestniJmeno FROM Pracovnik
	WHERE dbo.GetPocetSchvalenychHodinPracovnika(PracovnikID) >= 100

GO

DROP FUNCTION dbo.GetPocetSchvalenychHodinPracovnika



/*************************************************************************************/
/* Set-based dotaz (pracovník je mezi pracovníky, kteøí...							 */
/*************************************************************************************/
				
-- Najdi pracovníky, kteøí mají 100 a více schválených hodin
-- Jiný zápis, podmínku vyhodnocujeme hromadnì (set-based)				
DBCC DROPCLEANBUFFERS 
SELECT PracovnikID, KrestniJmeno FROM Pracovnik
	-- obvykle JOINy na další detaily
	WHERE PracovnikID IN
		(SELECT TimesheetItem.PracovnikID
			FROM TimesheetItem
			WHERE 
				(TimesheetItem.SchvalenoKdy IS NOT NULL)
			GROUP BY TimesheetItem.PracovnikID
			HAVING SUM(PocetHodin) > 100)
GO


/*************************************************************************************/
/* Øádkový subdotaz (poddotaz je závislý na hodnotì z øádku)						 */
/*************************************************************************************/

-- Najdi pracovníky, kteøí mají 100 a více schválených hodin
-- Podmínku vyhodnocujeme pro každého pracovníka (row-based)
DBCC DROPCLEANBUFFERS 
SELECT PracovnikID, KrestniJmeno FROM Pracovnik
	WHERE 100 <= (
		SELECT SUM(PocetHodin)
			FROM TimesheetItem
			WHERE 
				(TimesheetItem.SchvalenoKdy IS NOT NULL)
				AND (TimesheetItem.PracovnikID = Pracovnik.PracovnikID))
GO
	

