SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNDeleteFinancialPlanningScenario2InvestmentByScenarioId]
	@FinancialPlanningScenarioId Bigint,	
	@StampUser varchar (255)
	
AS


Declare @Result int, @FinancialPlanningScenario2InvestmentId bigint

select	@FinancialPlanningScenario2InvestmentId = FinancialPlanningScenario2InvestmentId from TFinancialPlanningScenario2Investment where @FinancialPlanningScenarioId = FinancialPlanningScenarioId

Execute @Result = dbo.SpNAuditFinancialPlanningScenario2Investment @StampUser, @FinancialPlanningScenario2InvestmentId, 'D'

IF @Result  != 0 GOTO errh

DELETE T1 FROM TFinancialPlanningScenario2Investment T1
WHERE T1.FinancialPlanningScenario2InvestmentId = @FinancialPlanningScenario2InvestmentId --AND T1.ConcurrencyId = @ConcurrencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)
GO
