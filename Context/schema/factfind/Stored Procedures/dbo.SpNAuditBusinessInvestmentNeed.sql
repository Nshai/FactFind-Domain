SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditBusinessInvestmentNeed]
	@StampUser varchar (255),
	@BusinessInvestmentNeedId bigint,
	@StampAction char(1)
AS

INSERT INTO TBusinessInvestmentNeedAudit 
( CRMContactId, GoalDescription, StartDate, EndDate, 
		EstimatedCosts, ConcurrencyId, 
	BusinessInvestmentNeedId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, GoalDescription, StartDate, EndDate, 
		EstimatedCosts, ConcurrencyId, 
	BusinessInvestmentNeedId, @StampAction, GetDate(), @StampUser
FROM TBusinessInvestmentNeed
WHERE BusinessInvestmentNeedId = @BusinessInvestmentNeedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
