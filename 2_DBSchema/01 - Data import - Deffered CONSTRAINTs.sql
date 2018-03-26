/*
	"I don't use FK CONSTRAINTS, they complicate my life within mass data imports. I don't want to care of the statements order."
*/

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
	-- "WITH CHECK"!! 
	EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL"
	-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	SELECT * FROM Sales.CurrencyRate WHERE ToCurrencyCode='WUD'

ROLLBACK TRANSACTION -- Just demo
