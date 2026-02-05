SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningRecentFund]
	@StampUser varchar (255),
	@FinancialPlanningRecentFundId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningRecentFundAudit 
(CRMContactId, FundUnitId, DataAdded, ConcurrencyId,
	FinancialPlanningRecentFundId, StampAction, StampDateTime, StampUser)
SELECT  CRMContactId, FundUnitId, DataAdded, ConcurrencyId,
	FinancialPlanningRecentFundId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningRecentFund
WHERE FinancialPlanningRecentFundId = @FinancialPlanningRecentFundId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
