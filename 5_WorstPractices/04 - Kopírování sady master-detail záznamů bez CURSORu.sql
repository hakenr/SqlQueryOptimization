USE AdventureWorks2012
GO

-- Objednávky ke zkopírování a jejich øádky
SELECT * FROM Sales.SalesOrderHeader WHERE CustomerID = 13600
SELECT SalesOrderDetail.* FROM Sales.SalesOrderDetail
	INNER JOIN Sales.SalesOrderHeader ON (SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID)
	WHERE CustomerID = 13600


/*************************************************************************************************/
/* CURSOR-logika, row-based logika                                                               */
/* "Bez CURSORu to nejde, pro kopírování øádek objednávky neznám nová ID zkopírovaných hlavièek. */
/*************************************************************************************************/
CURSOR foreach (CurrentSalesOrderHeader in SalesOrderHeaderToCopy)
	INSERT INTO SalesOrderHeader VALUES(CurrentSalesOrderHeader)		-- Založím klon objednávky, SalesOrderID mi pøidìlí auto-increment (IDENTITY)
	@newID = SCOPE_IDENTITY()											-- Zjistím ID novì založené kopie
	INSERT SalesOrderDetail(SalesOrderID, ...) VALUES(@newID, ...)		-- Zjištìné ID použiju pøi klonování øádkù objednávky


/************************************************************/
/* BEZ CURSORù, set-based logika							*/							
/************************************************************/

CREATE TYPE [dbo].[IDsTuple] AS TABLE(OldID int, [NewID] int)
GO

BEGIN TRANSACTION
	DECLARE @OrdersMap IDsTuple

	-- MERGE = trik k získání source IDs do OUTPUTu (OUTPUT INSERTu zdrojová data nemá)
	MERGE INTO Sales.SalesOrderHeader AS tgt 
		USING (SELECT
					s.SalesOrderID, /* OldID pro OUTPUT map */      
					s.RevisionNumber,
					s.OrderDate,
					s.DueDate,
					s.ShipDate,
					s.[Status],
					s.OnlineOrderFlag,
					s.PurchaseOrderNumber,
					s.AccountNumber,
					s.CustomerID,
					s.SalesPersonID,
					s.TerritoryID,
					s.BillToAddressID,
					s.ShipToAddressID,
					s.ShipMethodID,
					s.CreditCardID,
					s.CreditCardApprovalCode,
					s.CurrencyRateID,
					s.SubTotal,
					s.TaxAmt,
					s.Freight,
					s.Comment
				FROM Sales.SalesOrderHeader s
				WHERE (s.CustomerID = 13600)
			) AS src
		ON (1 = 0) -- Nikdy MATCH, všechno INSERT ;-))
		WHEN NOT MATCHED THEN
			INSERT (
					RevisionNumber,
					OrderDate,
					DueDate,
					ShipDate,
					[Status],
					OnlineOrderFlag,
					PurchaseOrderNumber,
					AccountNumber,
					CustomerID,
					SalesPersonID,
					TerritoryID,
					BillToAddressID,
					ShipToAddressID,
					ShipMethodID,
					CreditCardID,
					CreditCardApprovalCode,
					CurrencyRateID,
					SubTotal,
					TaxAmt,
					Freight,
					Comment
			)
			VALUES
			(              
					src.RevisionNumber,
					src.OrderDate,
					src.DueDate,
					src.ShipDate,
					src.[Status],
					src.OnlineOrderFlag,
					src.PurchaseOrderNumber,
					src.AccountNumber,
					src.CustomerID,
					src.SalesPersonID,
					src.TerritoryID,
					src.BillToAddressID,
					src.ShipToAddressID,
					src.ShipMethodID,
					src.CreditCardID,
					src.CreditCardApprovalCode,
					src.CurrencyRateID,
					src.SubTotal,
					src.TaxAmt,
					src.Freight,
					src.Comment
			)
		OUTPUT src.SalesOrderID, inserted.SalesOrderID INTO @OrdersMap;	-- ;-)

	-- Náhled mapovací tabulky
	SELECT * FROM @OrdersMap

	-- Zkopírujeme øádky
	INSERT INTO Sales.SalesOrderDetail
		    (SalesOrderID,
		        CarrierTrackingNumber,
		        OrderQty,
		        ProductID,
		        SpecialOfferID,
		        UnitPrice,
		        UnitPriceDiscount
		    )
		SELECT
		        map.[NewID],
		        src.CarrierTrackingNumber,
		        src.OrderQty,
		        src.ProductID,
		        src.SpecialOfferID,
		        src.UnitPrice,
		        src.UnitPriceDiscount
		    FROM Sales.SalesOrderDetail src
				INNER JOIN @OrdersMap map ON (map.OldID = src.SalesOrderID)

	-- Výsledek
	SELECT * FROM Sales.SalesOrderHeader WHERE CustomerID = 13600
	SELECT SalesOrderDetail.* FROM Sales.SalesOrderDetail
		INNER JOIN Sales.SalesOrderHeader ON (SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID)
		WHERE CustomerID = 13600

ROLLBACK
