USE AdventureWorks2012
GO 


-- "Dejte mi inici�ly osob se�azen� podle k�estn�ho/p��jmen�"
SELECT 
		LEFT(p.FirstName, 1) AS FirstInitial,
		LEFT(p.LastName, 1) AS LastInitial
	FROM Person.Person p
	ORDER BY 1
	--ORDER BY LastInitial
GO

BEGIN TRANSACTION
GO

	-- Dejte mi storku, kde bych si to mohl �adit s�m
	CREATE PROCEDURE GetInitials
	(
	   @Sort varchar(20)
	)
	AS
	BEGIN
		SELECT
				LEFT(p.FirstName, 1) AS FirstInitial, 
				LEFT(p.LastName, 1) AS LastInitial
			FROM Person.Person p
			ORDER BY CASE @Sort WHEN 'first' THEN 1 ELSE 2 END
	END
	GO

	EXEC GetInitials @Sort = 'first'
	EXEC GetInitials @Sort = 'last'

ROLLBACK