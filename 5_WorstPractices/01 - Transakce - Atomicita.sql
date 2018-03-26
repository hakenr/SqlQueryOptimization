/*************************************************************************************/
/* Pøíprava situace																	 */
/*************************************************************************************/
USE WugDemo
DROP TABLE Ucet
GO

-- Primitivní tabulka ála bankovní úèet
CREATE TABLE Ucet
(
	UcetID int IDENTITY(1,1) NOT NULL,
	VlastnikID int NOT NULL,
	Zustatek money NOT NULL CONSTRAINT DF_Ucet_Zustatek  DEFAULT (0),
	CONSTRAINT PK_Ucet PRIMARY KEY CLUSTERED (UcetID ASC) 
) ON [PRIMARY]
GO





/*************************************************************************************/
/* Nechránìná operace																 */
/*************************************************************************************/

-- Založení dvou ukázkových úètù s nulovým zùstatkem (default)
INSERT INTO Ucet(VlastnikID) VALUES(1)
INSERT INTO Ucet(VlastnikID) VALUES(2)
GO

-- Operace mezi úèty nechránìné transakcí
UPDATE Ucet SET Zustatek = Zustatek - 500 WHERE VlastnikID = 1
UPDATE Ucet SET Zustatek = Zustatek + 500 WHERE VlastnikID = 2
GO

-- Co bude na úètech?
SELECT * FROM Ucet
GO






/*************************************************************************************/
/* Transakce																		 */
/*************************************************************************************/

-- Pøíprava
DELETE FROM Ucet
INSERT INTO Ucet(VlastnikID) VALUES(1)
INSERT INTO Ucet(VlastnikID) VALUES(2)
GO

-- Transakce
BEGIN TRANSACTION
	UPDATE Ucet SET Zustatek = Zustatek - 500 WHERE VlastnikID = 1
	UPDATE Ucet SET Zustatek = Zustatek + 500 WHERE VlastnikID = 2
COMMIT TRANSACTION
GO

-- Co bude na úètech?
SELECT * FROM Ucet
GO






/************************************************************************************/
/* Transakce - Test pomocí problémové situace										*/
/************************************************************************************/

-- Vrátíme úèty na nulový zùstatek
DELETE FROM Ucet
INSERT INTO Ucet(VlastnikID) VALUES(1)
INSERT INTO Ucet(VlastnikID) VALUES(2)
GO

-- Pøidáme constraint - Záporný zùstatek nepøipouštíme
ALTER TABLE Ucet WITH CHECK ADD CONSTRAINT CK_Ucet_NezapornyZustatek CHECK (Zustatek >=0)
GO

-- Transakce
BEGIN TRANSACTION
	-- Záporný zùstatek na úètu nepøipouštíme, první UPDATE failuje
	UPDATE Ucet SET Zustatek = Zustatek - 500 WHERE VlastnikID = 1
	UPDATE Ucet SET Zustatek = Zustatek + 500 WHERE VlastnikID = 2
COMMIT TRANSACTION
GO

-- Co bude na úètech?
SELECT * FROM Ucet
GO













/*************************************************************************************/
/* Transakce - korekce se SET XACT_ABORT											 */
/*************************************************************************************/

/*
When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error,
the entire transaction is terminated and rolled back. 

Compile errors, such as syntax errors, are not affected by SET XACT_ABORT.
*/

-- Pøíprava situace
DELETE FROM Ucet
INSERT INTO Ucet(VlastnikID) VALUES(1)
INSERT INTO Ucet(VlastnikID) VALUES(2)
GO

-- Zapneme XACT_ABORT
SET XACT_ABORT ON
GO

-- Pøevod 500 Kè z úètu na úèet
BEGIN TRANSACTION
	
	-- Pøíkaz failuje, zùstatek nesmí být záporný
	UPDATE Ucet SET Zustatek = Zustatek - 500 WHERE VlastnikID = 1

	UPDATE Ucet SET Zustatek = Zustatek + 500 WHERE VlastnikID = 2

COMMIT TRANSACTION
GO

-- Co bude na úètech?
SELECT * FROM Ucet
GO




	






/*************************************************************************************/
/* Transakce - korekce s kontrolou @@ERROR ("old-fashioned")						 */
/*************************************************************************************/

-- Nyní XACT_ABORT nechceme
SET XACT_ABORT OFF

-- Pøíprava situace
DELETE FROM Ucet
INSERT INTO Ucet(VlastnikID) VALUES(1)
INSERT INTO Ucet(VlastnikID) VALUES(2)
GO

-- Pøevod 500 Kè z úètu na úèet
BEGIN TRANSACTION
	
	-- Pøíkaz failuje, zùstatek nesmí být záporný
	UPDATE Ucet SET Zustatek = Zustatek - 500 WHERE VlastnikID = 1
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION -- Odvoláme transakci
		RETURN -- Rollback nestaèí, musíme opustit batch a zabránit volání dalších pøíkazù!
	END

	UPDATE Ucet SET Zustatek = Zustatek + 500 WHERE VlastnikID = 2
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION -- Odvoláme transakci
		RETURN -- Rollback nestaèí, musíme opustit batch a zabránit volání dalších pøíkazù!
	END

COMMIT TRANSACTION
GO

-- Co bude na úètech?
SELECT * FROM Ucet
GO









/*************************************************************************************/
/* Transakce - TRY-CATCH na SQL 2005+												 */
/*************************************************************************************/

-- Pøíprava situace
DELETE FROM Ucet
INSERT INTO Ucet(VlastnikID) VALUES(1)
INSERT INTO Ucet(VlastnikID) VALUES(2)
GO

-- Pøevod 500 Kè z úètu na úèet
BEGIN TRANSACTION

	BEGIN TRY	
		-- Pøíkaz failuje, zùstatek nesmí být záporný
		UPDATE Ucet SET Zustatek = Zustatek - 500 WHERE VlastnikID = 1

		UPDATE Ucet SET Zustatek = Zustatek + 500 WHERE VlastnikID = 2
	END TRY
	BEGIN CATCH
		-- Podrobnosti o chybì
	   SELECT 
		  ERROR_NUMBER() AS ErrorNumber,
		  ERROR_SEVERITY() AS ErrorSeverity,
		  ERROR_STATE() as ErrorState,
		  ERROR_PROCEDURE() as ErrorProcedure,
		  ERROR_LINE() as ErrorLine,
		  ERROR_MESSAGE() as ErrorMessage;

		ROLLBACK TRANSACTION
		RETURN
	END CATCH

IF (@@TRANCOUNT > 0) -- Díky RETURN výše není ani potøeba
	COMMIT TRANSACTION
GO

-- Co bude na úètech?
SELECT * FROM Ucet
GO