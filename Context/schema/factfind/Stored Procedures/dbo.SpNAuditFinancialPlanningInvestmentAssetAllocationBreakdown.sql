SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningInvestmentAssetAllocationBreakdown]
	@StampUser varchar (255),
	@FinancialPlanningInvestmentAssetAllocationBreakdownId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningInvestmentAssetAllocationBreakdownAudit 
(FinancialPlanningInvestmentAssetAllocationId, AssetClass, AllocationPercentage, ConcurrencyId,
	FinancialPlanningInvestmentAssetAllocationBreakdownId, StampAction, StampDateTime, StampUser)
SELECT  FinancialPlanningInvestmentAssetAllocationId, AssetClass, AllocationPercentage, ConcurrencyId,
	FinancialPlanningInvestmentAssetAllocationBreakdownId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningInvestmentAssetAllocationBreakdown
WHERE FinancialPlanningInvestmentAssetAllocationBreakdownId = @FinancialPlanningInvestmentAssetAllocationBreakdownId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
