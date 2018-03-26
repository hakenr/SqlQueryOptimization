USE AdventureWorks2012
GO

-- Objedn�vky ke zkop�rov�n� a jejich ��dky
SELECT * FROM Sales.SalesOrderHeader WHERE CustomerID = 13600
SELECT SalesOrderDetail.* FROM Sales.SalesOrderDetail
	INNER JOIN Sales.SalesOrderHeader ON (SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID)
	WHERE CustomerID = 13600


/*************************************************************************************************/
/* CURSOR-logika, row-based logika                                                               */
/* "Bez CURSORu to nejde, pro kop�rov�n� ��dek objedn�vky nezn�m nov� ID zkop�rovan�ch hlavi�ek. */
/*************************************************************************************************/
CURSOR foreach (CurrentSalesOrderHeader in SalesOrderHeaderToCopy)
	INSERT INTO SalesOrderHeader VALUES(CurrentSalesOrderHeader)		-- Zalo��m klon objedn�vky, SalesOrderID mi p�id�l� auto-increment (IDENTITY)
	@newID = SCOPE_IDENTITY()											-- Zjist�m ID nov� zalo�en� kopie
	INSERT SalesOrderDetail(SalesOrderID, ...) VALUES(@newID, ...)		-- Zji�t�n� ID pou�iju p�i klonov�n� ��dk� objedn�vky


/************************************************************/
/* BEZ CURSOR�, set-based logika							*/							
/************************************************************/

CREATE TYPE [dbo].[IDsTuple] AS TABLE(OldID int, [NewID] int)
GO

BEGIN TRANSACTION
	DECLARE @OrdersMap IDsTuple

	-- MERGE = trik k z�sk�n� source IDs do OUTPUTu (OUTPUT INSERTu zdrojov� data nem�)
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
		ON (1 = 0) -- Nikdy MATCH, v�echno INSERT ;-))
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

	-- N�hled mapovac� tabulky
	SELECT * FROM @OrdersMap

	-- Zkop�rujeme ��dky
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

	-- V�sledek
	SELECT * FROM Sales.SalesOrderHeader WHERE CustomerID = 13600
	SELECT SalesOrderDetail.* FROM Sales.SalesOrderDetail
		INNER JOIN Sales.SalesOrderHeader ON (SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID)
		WHERE CustomerID = 13600

ROLLBACK
