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


-- Zalo�en� n�kolika uk�zkov�ch ��t�
DELETE FROM Ucet
INSERT INTO Ucet(VlastnikID, Zustatek) VALUES(1, 10)
INSERT INTO Ucet(VlastnikID, Zustatek) VALUES(2, 20)
INSERT INTO Ucet(VlastnikID, Zustatek) VALUES(3, 30)
INSERT INTO Ucet(VlastnikID, Zustatek) VALUES(4, 40)
INSERT INTO Ucet(VlastnikID, Zustatek) VALUES(5, 50)
GO

-- Kontroln� v�stup
SELECT * FROM Ucet
GO