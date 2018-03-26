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


-- Založení nìkolika ukázkových úètù
DELETE FROM Ucet
INSERT INTO Ucet(VlastnikID, Zustatek) VALUES(1, 10)
INSERT INTO Ucet(VlastnikID, Zustatek) VALUES(2, 20)
INSERT INTO Ucet(VlastnikID, Zustatek) VALUES(3, 30)
INSERT INTO Ucet(VlastnikID, Zustatek) VALUES(4, 40)
INSERT INTO Ucet(VlastnikID, Zustatek) VALUES(5, 50)
GO

-- Kontrolní výstup
SELECT * FROM Ucet
GO