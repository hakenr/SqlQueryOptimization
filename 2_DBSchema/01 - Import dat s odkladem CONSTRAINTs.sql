/*
	"FK CONSTRAINTS nepou��v�m, proto�e mi komplikuj� �ivot p�i hromadn�ch importech dat. Nap�. po�ad� vkl�d�n� z�znam�."
*/

USE AdventureWorks2012
SET XACT_ABORT ON
BEGIN TRANSACTION

	-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL"
	-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	INSERT INTO Sales.CurrencyRate(CurrencyRateDate, FromCurrencyCode, ToCurrencyCode, AverageRate, EndOfDayRate)
		VALUES
			('20130522', 'USD', 'WUD', 15.35, 15.42),
			('20130523', 'USD', 'WUD', 15.36, 15.30)

	-- INSERT INTO Sales.Currency(CurrencyCode, Name) VALUES ('WUD', 'WUG Dolar')

	SELECT * FROM Sales.CurrencyRate WHERE ToCurrencyCode='WUD'

	-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	-- Pozor na "WITH CHECK"!! 
	EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL"
	-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	SELECT * FROM Sales.CurrencyRate WHERE ToCurrencyCode='WUD'

ROLLBACK TRANSACTION -- Jen demo, v produkci samoz�ejm� COMMIT, o�et�it chyby, atp.
