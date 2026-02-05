SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFinancialPlanningSelectedInvestments]
	@StampUser varchar (255),
	@FinancialPlanningSelectedInvestmentsId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningSelectedInvestmentsAudit 
( FinancialPlanningId, InvestmentId, InvestmentType, ConcurrencyId, 
		
	FinancialPlanningSelectedInvestmentsId, StampAction, StampDateTime, StampUser) 
Select FinancialPlanningId, InvestmentId, InvestmentType, ConcurrencyId, 
		
	FinancialPlanningSelectedInvestmentsId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningSelectedInvestments
WHERE FinancialPlanningSelectedInvestmentsId = @FinancialPlanningSelectedInvestmentsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
