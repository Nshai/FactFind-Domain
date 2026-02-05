SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFundAssetSummary]
	@StampUser varchar (255),
	@FundAssetSummaryId bigint,
	@StampAction char(1)
AS

INSERT INTO TFundAssetSummaryAudit 
	(EquityId, FundId, IsEquity, IsFromFeed, UpdatedByUserId, UpdatedOn, TenantId, ConcurrencyId, FundAssetSummaryId, StampAction, StampDateTime, StampUser)	

Select EquityId, FundId, IsEquity, IsFromFeed, UpdatedByUserId, UpdatedOn, TenantId, ConcurrencyId, FundAssetSummaryId, @StampAction, GetDate(), @StampUser
FROM TFundAssetSummary
WHERE FundAssetSummaryId = @FundAssetSummaryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
