SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFinancialPlanningScenario2Investment]
	@StampUser varchar (255),
	@FinancialPlanningScenario2InvestmentId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningScenario2InvestmentAudit 
( FinancialPlanningScenarioId, InvestmentId, InvestmentType, ConcurrencyId, 
		
	FinancialPlanningScenario2InvestmentId, StampAction, StampDateTime, StampUser) 
Select FinancialPlanningScenarioId, InvestmentId, InvestmentType, ConcurrencyId, 
		
	FinancialPlanningScenario2InvestmentId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningScenario2Investment
WHERE FinancialPlanningScenario2InvestmentId = @FinancialPlanningScenario2InvestmentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
