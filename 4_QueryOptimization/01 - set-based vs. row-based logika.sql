/*************************************************************************************/
/* P��prava situace																	 */
/*************************************************************************************/

USE GoranSample
DROP FUNCTION dbo.GetPocetSchvalenychHodinPracovnika
GO

SET STATISTICS TIME ON
SET STATISTICS IO ON
-- Execution plans

/*************************************************************************************/
/* ��dkov� funkce																	 */
/*************************************************************************************/

-- Najdi pracovn�ky, kte�� maj� 100 a v�ce schv�len�ch hodin
-- Funkce pro zji�t�n� po�tu schv�len�ch hodin pracovn�ka
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

-- Podm�nku vyhodnocujeme pro ka�d�ho pracovn�ka (row-based function)
DBCC DROPCLEANBUFFERS 
SELECT PracovnikID, KrestniJmeno FROM Pracovnik
	WHERE dbo.GetPocetSchvalenychHodinPracovnika(PracovnikID) >= 100

GO

DROP FUNCTION dbo.GetPocetSchvalenychHodinPracovnika



/*************************************************************************************/
/* Set-based dotaz (pracovn�k je mezi pracovn�ky, kte��...							 */
/*************************************************************************************/
				
-- Najdi pracovn�ky, kte�� maj� 100 a v�ce schv�len�ch hodin
-- Jin� z�pis, podm�nku vyhodnocujeme hromadn� (set-based)				
DBCC DROPCLEANBUFFERS 
SELECT PracovnikID, KrestniJmeno FROM Pracovnik
	-- obvykle JOINy na dal�� detaily
	WHERE PracovnikID IN
		(SELECT TimesheetItem.PracovnikID
			FROM TimesheetItem
			WHERE 
				(TimesheetItem.SchvalenoKdy IS NOT NULL)
			GROUP BY TimesheetItem.PracovnikID
			HAVING SUM(PocetHodin) > 100)
GO


/*************************************************************************************/
/* ��dkov� subdotaz (poddotaz je z�visl� na hodnot� z ��dku)						 */
/*************************************************************************************/

-- Najdi pracovn�ky, kte�� maj� 100 a v�ce schv�len�ch hodin
-- Podm�nku vyhodnocujeme pro ka�d�ho pracovn�ka (row-based)
DBCC DROPCLEANBUFFERS 
SELECT PracovnikID, KrestniJmeno FROM Pracovnik
	WHERE 100 <= (
		SELECT SUM(PocetHodin)
			FROM TimesheetItem
			WHERE 
				(TimesheetItem.SchvalenoKdy IS NOT NULL)
				AND (TimesheetItem.PracovnikID = Pracovnik.PracovnikID))
GO
	

