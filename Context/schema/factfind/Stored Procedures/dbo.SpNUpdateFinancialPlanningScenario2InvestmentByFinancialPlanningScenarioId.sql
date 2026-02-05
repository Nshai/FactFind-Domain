SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNUpdateFinancialPlanningScenario2InvestmentByFinancialPlanningScenarioId]
	@StampUser varchar(50),
	@FinancialPlanningScenarioId Bigint,
	@InvestmentId bigint,
	@InvestmentType varchar(50)
	
AS


Declare @Result int, @FinancialPlanningScenario2InvestmentId bigint

select @FinancialPlanningScenario2InvestmentId = FinancialPlanningScenario2InvestmentId from TFinancialPlanningScenario2Investment where FinancialPlanningScenarioId = @FinancialPlanningScenarioId

Execute @Result = dbo.SpNAuditFinancialPlanningScenario2Investment @StampUser, @FinancialPlanningScenario2InvestmentId, 'U'

IF @Result  != 0 GOTO errh

update T1 
set	InvestmentId = @InvestmentId,
	InvestmentType = @InvestmentType,
	ConcurrencyId = ConcurrencyId + 1
FROM TFinancialPlanningScenario2Investment T1
WHERE T1.FinancialPlanningScenarioId = @FinancialPlanningScenarioId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)
GO
