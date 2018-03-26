/*************************************************************************************/
/* Pøíprava situace																	 */
/*************************************************************************************/
USE WugDemo
DROP TABLE Ucet
DROP TABLE Zurnal
GO

-- Primitivní tabulka ála bankovní úèet
CREATE TABLE Ucet
(
	UcetID int IDENTITY(1,1) NOT NULL,
	VlastnikID int NOT NULL,
	CONSTRAINT PK_Ucet PRIMARY KEY CLUSTERED (UcetID ASC) 
) ON [PRIMARY]
GO

-- Tabulka Zurnal pro logování operací
CREATE TABLE Zurnal
(
	ZurnalID int IDENTITY(100,1) NOT NULL,    -- ID od 100
	Data nvarchar(MAX),
	CONSTRAINT PK_Zurnal PRIMARY KEY CLUSTERED (ZurnalID ASC) 
) ON [PRIMARY]
GO

-- Tabulka Zurnal pro logování operací
CREATE TRIGGER Ucet_Insert ON Ucet FOR INSERT
AS
	INSERT INTO Zurnal(Data) VALUES('BlaBla')
GO


/*************************************************************************************/
/* @@IDENTITY vs. SCOPE_IDENTITY()													 */
/*************************************************************************************/

INSERT INTO Ucet(VlastnikID) VALUES(1)

SELECT @@IDENTITY
SELECT SCOPE_IDENTITY()
