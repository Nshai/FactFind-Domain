SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFundAssetAllocation]
	@StampUser varchar (255),
	@FundAssetAllocationId bigint,
	@StampAction char(1)
AS

INSERT INTO TFundAssetAllocationAudit 
	(FundAssetSummaryId, AtrRefAssetClassId, PercentageAllocation, ConcurrencyId, FundAssetAllocationId, StampAction, StampDateTime, StampUser)	

Select FundAssetSummaryId, AtrRefAssetClassId, PercentageAllocation, ConcurrencyId, FundAssetAllocationId, @StampAction, GetDate(), @StampUser
FROM TFundAssetAllocation
WHERE FundAssetAllocationId = @FundAssetAllocationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
