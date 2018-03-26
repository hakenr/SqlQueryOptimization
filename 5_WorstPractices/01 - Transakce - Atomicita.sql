/*************************************************************************************/
/* P��prava situace																	 */
/*************************************************************************************/
USE WugDemo
DROP TABLE Ucet
GO

-- Primitivn� tabulka �la bankovn� ��et
CREATE TABLE Ucet
(
	UcetID int IDENTITY(1,1) NOT NULL,
	VlastnikID int NOT NULL,
	Zustatek money NOT NULL CONSTRAINT DF_Ucet_Zustatek  DEFAULT (0),
	CONSTRAINT PK_Ucet PRIMARY KEY CLUSTERED (UcetID ASC) 
) ON [PRIMARY]
GO





/*************************************************************************************/
/* Nechr�n�n� operace																 */
/*************************************************************************************/

-- Zalo�en� dvou uk�zkov�ch ��t� s nulov�m z�statkem (default)
INSERT INTO Ucet(VlastnikID) VALUES(1)
INSERT INTO Ucet(VlastnikID) VALUES(2)
GO

-- Operace mezi ��ty nechr�n�n� transakc�
UPDATE Ucet SET Zustatek = Zustatek - 500 WHERE VlastnikID = 1
UPDATE Ucet SET Zustatek = Zustatek + 500 WHERE VlastnikID = 2
GO

-- Co bude na ��tech?
SELECT * FROM Ucet
GO






/*************************************************************************************/
/* Transakce																		 */
/*************************************************************************************/

-- P��prava
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

-- Co bude na ��tech?
SELECT * FROM Ucet
GO






/************************************************************************************/
/* Transakce - Test pomoc� probl�mov� situace										*/
/************************************************************************************/

-- Vr�t�me ��ty na nulov� z�statek
DELETE FROM Ucet
INSERT INTO Ucet(VlastnikID) VALUES(1)
INSERT INTO Ucet(VlastnikID) VALUES(2)
GO

-- P�id�me constraint - Z�porn� z�statek nep�ipou�t�me
ALTER TABLE Ucet WITH CHECK ADD CONSTRAINT CK_Ucet_NezapornyZustatek CHECK (Zustatek >=0)
GO

-- Transakce
BEGIN TRANSACTION
	-- Z�porn� z�statek na ��tu nep�ipou�t�me, prvn� UPDATE failuje
	UPDATE Ucet SET Zustatek = Zustatek - 500 WHERE VlastnikID = 1
	UPDATE Ucet SET Zustatek = Zustatek + 500 WHERE VlastnikID = 2
COMMIT TRANSACTION
GO

-- Co bude na ��tech?
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

-- P��prava situace
DELETE FROM Ucet
INSERT INTO Ucet(VlastnikID) VALUES(1)
INSERT INTO Ucet(VlastnikID) VALUES(2)
GO

-- Zapneme XACT_ABORT
SET XACT_ABORT ON
GO

-- P�evod 500 K� z ��tu na ��et
BEGIN TRANSACTION
	
	-- P��kaz failuje, z�statek nesm� b�t z�porn�
	UPDATE Ucet SET Zustatek = Zustatek - 500 WHERE VlastnikID = 1

	UPDATE Ucet SET Zustatek = Zustatek + 500 WHERE VlastnikID = 2

COMMIT TRANSACTION
GO

-- Co bude na ��tech?
SELECT * FROM Ucet
GO




	






/*************************************************************************************/
/* Transakce - korekce s kontrolou @@ERROR ("old-fashioned")						 */
/*************************************************************************************/

-- Nyn� XACT_ABORT nechceme
SET XACT_ABORT OFF

-- P��prava situace
DELETE FROM Ucet
INSERT INTO Ucet(VlastnikID) VALUES(1)
INSERT INTO Ucet(VlastnikID) VALUES(2)
GO

-- P�evod 500 K� z ��tu na ��et
BEGIN TRANSACTION
	
	-- P��kaz failuje, z�statek nesm� b�t z�porn�
	UPDATE Ucet SET Zustatek = Zustatek - 500 WHERE VlastnikID = 1
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION -- Odvol�me transakci
		RETURN -- Rollback nesta��, mus�me opustit batch a zabr�nit vol�n� dal��ch p��kaz�!
	END

	UPDATE Ucet SET Zustatek = Zustatek + 500 WHERE VlastnikID = 2
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION -- Odvol�me transakci
		RETURN -- Rollback nesta��, mus�me opustit batch a zabr�nit vol�n� dal��ch p��kaz�!
	END

COMMIT TRANSACTION
GO

-- Co bude na ��tech?
SELECT * FROM Ucet
GO









/*************************************************************************************/
/* Transakce - TRY-CATCH na SQL 2005+												 */
/*************************************************************************************/

-- P��prava situace
DELETE FROM Ucet
INSERT INTO Ucet(VlastnikID) VALUES(1)
INSERT INTO Ucet(VlastnikID) VALUES(2)
GO

-- P�evod 500 K� z ��tu na ��et
BEGIN TRANSACTION

	BEGIN TRY	
		-- P��kaz failuje, z�statek nesm� b�t z�porn�
		UPDATE Ucet SET Zustatek = Zustatek - 500 WHERE VlastnikID = 1

		UPDATE Ucet SET Zustatek = Zustatek + 500 WHERE VlastnikID = 2
	END TRY
	BEGIN CATCH
		-- Podrobnosti o chyb�
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

IF (@@TRANCOUNT > 0) -- D�ky RETURN v��e nen� ani pot�eba
	COMMIT TRANSACTION
GO

-- Co bude na ��tech?
SELECT * FROM Ucet
GO