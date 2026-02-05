SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[nio_SpCustomAddFundPriceOverride](
	@FundId bigint,
	@FundTypeId bigint,
	@FromFeedFg bit,
	@PriceDate datetime,
	@Price float,
	@UpdateForChildClients bit,
	@TenantId bigint,
	@UpdatedBy varchar(50)
)
AS

SET QUOTED_IDENTIFIER ON

IF (SELECT COUNT(*) FROM TFundPriceOverride WHERE FundId = @FundId AND FundTypeId = @FundTypeId AND IndigoClientId = @TenantId AND FromFeedFg = @FromFeedFg) > 0
		-- record already exists, update it
	UPDATE TFundPriceOverride
	SET 
		PriceDate = @PriceDate,
		Price = @Price,
		PriceUpdatedBy = @UpdatedBy
	WHERE 
		FundId = @FundId
		AND FundTypeId = @FundTypeId
		AND FromFeedFg = @FromFeedFg
ELSE
	-- insert a new record
	INSERT INTO TFundPriceOverride (FundId, FundTypeId, FromFeedFg, PriceDate, Price, PriceUpdatedBy, IndigoClientId)
	VALUES (@FundId, @FundTypeId, @FromFeedFg, @PriceDate, @Price, @UpdatedBy, @TenantId)


IF @FromFeedFg = 0
BEGIN
	-- update the fund record with the new price
	UPDATE TNonFeedFund
	SET 
		CurrentPrice = @Price,
		PriceDate = @PriceDate,
		PriceUpdatedByUser = @UpdatedBy
	WHERE 
		NonFeedFundId = @FundId
		AND IndigoClientId = @TenantId

	-- update the history
	EXEC [nio_NonFeedFundPriceHistory_SaveOrUpdate] @FundId, @PriceDate, @Price
END

-- Add our tenant to the list..
CREATE TABLE #Tenants (Id int)
INSERT INTO #Tenants (Id) VALUES (@TenantId)

-- See if we are updating across the network..
IF @UpdateForChildClients = 1
	INSERT INTO #Tenants
	SELECT IndigoClientId
	FROM Administration..TIndigoClient
	WHERE NetworkId = @TenantId

-- Update funds
UPDATE PBF
SET 
	CurrentPrice = @Price * ISNULL(policymanagement.dbo.FnGetCurrencyRate('', PB.BaseCurrency), 1.0),
	LastPriceChangeDate = @PriceDate,
	PriceUpdatedByUser = @UpdatedBy
FROM 
	TPolicyBusinessFund PBF
	JOIN TPolicyBusiness PB ON PB.PolicyBusinessId = PBF.PolicyBusinessId
	JOIN #Tenants T ON T.Id = PB.IndigoClientId
WHERE 	
	FundId = @FundId
	AND FromFeedFg = @FromFeedFg
	AND LastPriceChangeDate <= @PriceDate
	-- For manual funds we don't care about type
	-- For feed funds we need to distinguish between fund/equity
	AND (@FromFeedFg = 0 OR FundTypeId = @FundTypeId)

SELECT 1
GO