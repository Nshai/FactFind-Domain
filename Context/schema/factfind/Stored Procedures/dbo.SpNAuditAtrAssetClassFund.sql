SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrAssetClassFund]
	@StampUser varchar (255),
	@AtrAssetClassFundId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrAssetClassFundAudit 
( AtrAssetClassGuid, FundId, FundTypeId, FromFeed, 
		Recommended, IndigoClientId, ConcurrencyId, 
	AtrAssetClassFundId, StampAction, StampDateTime, StampUser) 
Select AtrAssetClassGuid, FundId, FundTypeId, FromFeed, 
		Recommended, IndigoClientId, ConcurrencyId, 
	AtrAssetClassFundId, @StampAction, GetDate(), @StampUser
FROM TAtrAssetClassFund
WHERE AtrAssetClassFundId = @AtrAssetClassFundId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
