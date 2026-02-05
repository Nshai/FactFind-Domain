SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFinancialPlanningScenarioAssetSplits]
	@StampUser varchar (255),
	@FinancialPlanningScenarioAssetSplitsId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningScenarioAssetSplitsAudit 
( FinancialPlanningId, ScenarioId, Cash, Property, 
		FixedInterest, UKEquity, OverseasEquity, SpecialistEquity, 
		ConcurrencyId, 
	FinancialPlanningScenarioAssetSplitsId, StampAction, StampDateTime, StampUser) 
Select FinancialPlanningId, ScenarioId, Cash, Property, 
		FixedInterest, UKEquity, OverseasEquity, SpecialistEquity, 
		ConcurrencyId, 
	FinancialPlanningScenarioAssetSplitsId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningScenarioAssetSplits
WHERE FinancialPlanningScenarioAssetSplitsId = @FinancialPlanningScenarioAssetSplitsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
