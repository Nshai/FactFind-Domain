SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditNonFeedFundAtrAssetClass]
	@StampUser varchar (255),
	@NonFeedFundAtrAssetClassId int,
	@StampAction char(1)
AS

INSERT INTO TNonFeedFundAtrAssetClassAudit 
( NonFeedFundId, Recommended, TenantId, AtrRefAssetClassId, 
		Allocation, IsEquity, ConcurrencyId, 
	NonFeedFundAtrAssetClassId, StampAction, StampDateTime, StampUser) 
Select NonFeedFundId, Recommended, TenantId, AtrRefAssetClassId, 
		Allocation, IsEquity, ConcurrencyId, 
	NonFeedFundAtrAssetClassId, @StampAction, GetDate(), @StampUser
FROM TNonFeedFundAtrAssetClass
WHERE NonFeedFundAtrAssetClassId = @NonFeedFundAtrAssetClassId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
