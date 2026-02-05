SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditNonFeedFund]
	@StampUser varchar (255),
	@NonFeedFundId bigint,
	@StampAction char(1)
AS

INSERT INTO TNonFeedFundAudit 
( FundTypeId, FundTypeName, FundName, CompanyId, 
		CompanyName, CategoryId, CategoryName, Sedol, 
		MexId, IndigoClientId, CurrentPrice, PriceDate, 
		PriceUpdatedByUser, ConcurrencyId, 
	NonFeedFundId, StampAction, StampDateTime, StampUser, 
	ISIN,Epic,Citi,ProviderFundCode,RefProdProviderId,LastUpdatedByPlan)
Select FundTypeId, FundTypeName, FundName, CompanyId, 
		CompanyName, CategoryId, CategoryName, Sedol, 
		MexId, IndigoClientId, CurrentPrice, PriceDate, 
		PriceUpdatedByUser, ConcurrencyId, 
	NonFeedFundId, @StampAction, GetDate(), @StampUser,
	ISIN,Epic,Citi,ProviderFundCode,RefProdProviderId,LastUpdatedByPlan
FROM TNonFeedFund WITH (READPAST)
WHERE NonFeedFundId = @NonFeedFundId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
