SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditSavingsGoalsNeeds]
	@StampUser varchar (255),
	@SavingsGoalsNeedsId bigint,
	@StampAction char(1)
AS

INSERT INTO TSavingsGoalsNeedsAudit 
( CRMContactId, GoalsAndNeeds, ConcurrencyId, 
	SavingsGoalsNeedsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, GoalsAndNeeds, ConcurrencyId, 
	SavingsGoalsNeedsId, @StampAction, GetDate(), @StampUser
FROM TSavingsGoalsNeeds
WHERE SavingsGoalsNeedsId = @SavingsGoalsNeedsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
