SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFinancialPlanningSelectedFunds]
	@StampUser varchar (255),
	@FinancialPlanningSelectedFundsId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningSelectedFundsAudit 
( FinancialPlanningSelectedInvestmentsId, PolicyBusinessFundId, IsAsset, ConcurrencyId, 
		
	FinancialPlanningSelectedFundsId, StampAction, StampDateTime, StampUser) 
Select FinancialPlanningSelectedInvestmentsId, PolicyBusinessFundId, IsAsset, ConcurrencyId, 
		
	FinancialPlanningSelectedFundsId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningSelectedFunds
WHERE FinancialPlanningSelectedFundsId = @FinancialPlanningSelectedFundsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
