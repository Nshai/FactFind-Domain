SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFinancialPlanningInvestmentAssetAllocation]
	@StampUser varchar (255),
	@FinancialPlanningInvestmentAssetAllocationId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningInvestmentAssetAllocationAudit 
( FinancialPlanningId, InvestmentId, InvestmentType, Cash, 
		Property, FixedInterest, UKEquities, OverseasEquities, 
		SpecialistEquities, ConcurrencyId, 
	FinancialPlanningInvestmentAssetAllocationId, StampAction, StampDateTime, StampUser) 
Select FinancialPlanningId, InvestmentId, InvestmentType, Cash, 
		Property, FixedInterest, UKEquities, OverseasEquities, 
		SpecialistEquities, ConcurrencyId, 
	FinancialPlanningInvestmentAssetAllocationId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningInvestmentAssetAllocation
WHERE FinancialPlanningInvestmentAssetAllocationId = @FinancialPlanningInvestmentAssetAllocationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
