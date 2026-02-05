SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateFPScenarioName]
	@StampUser varchar (255),	
	@FinancialPlanningScenarioId Bigint,	
	@Scenario char(1) 
AS


Declare @Result int
Execute @Result = dbo.SpNAuditFinancialPlanningScenario @StampUser, @FinancialPlanningScenarioId, 'U'

IF @Result  != 0 GOTO errh

UPDATE	T1
SET		T1.Scenario = @Scenario,
		T1.ConcurrencyId = T1.ConcurrencyId + 1
FROM TFinancialPlanningScenario T1
WHERE  T1.FinancialPlanningScenarioId = @FinancialPlanningScenarioId

IF @@ERROR != 0 GOTO errh

RETURN (0)	
errh:
RETURN (100)
GO
