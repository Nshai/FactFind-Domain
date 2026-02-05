SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNDeleteFinancialPlanningScenario]
	@FinancialPlanningScenarioId Bigint,	
	@StampUser varchar (255)
	
AS


Declare @Result int
Execute @Result = dbo.SpNAuditFinancialPlanningScenario @StampUser, @FinancialPlanningScenarioId, 'D'

IF @Result  != 0 GOTO errh

DELETE T1 FROM TFinancialPlanningScenario T1
WHERE T1.FinancialPlanningScenarioId = @FinancialPlanningScenarioId --AND T1.ConcurrencyId = @ConcurrencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)
GO
