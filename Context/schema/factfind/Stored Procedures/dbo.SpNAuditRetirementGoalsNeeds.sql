SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRetirementGoalsNeeds]
	@StampUser varchar (255),
	@RetirementGoalsNeedsId bigint,
	@StampAction char(1)
AS

INSERT INTO TRetirementGoalsNeedsAudit 
( CRMContactId, GoalsAndNeeds, ConcurrencyId, 
	RetirementGoalsNeedsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, GoalsAndNeeds, ConcurrencyId, 
	RetirementGoalsNeedsId, @StampAction, GetDate(), @StampUser
FROM TRetirementGoalsNeeds
WHERE RetirementGoalsNeedsId = @RetirementGoalsNeedsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
