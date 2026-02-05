SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningSelectedFundsRevised]
	@StampUser varchar (255),
	@FinancialPlanningSelectedFundsRevisedId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningSelectedFundsRevisedAudit 
(FinancialPlanningSelectedFundsId, PolicyBusinessFundId, RevisedValue, RevisedPercentage, IsLocked,IsExecuted, ConcurrencyId,
	FinancialPlanningSelectedFundsRevisedId, StampAction, StampDateTime, StampUser)
SELECT  FinancialPlanningSelectedFundsId, PolicyBusinessFundId, RevisedValue, RevisedPercentage, IsLocked,IsExecuted, ConcurrencyId,
	FinancialPlanningSelectedFundsRevisedId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningSelectedFundsRevised
WHERE FinancialPlanningSelectedFundsRevisedId = @FinancialPlanningSelectedFundsRevisedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
