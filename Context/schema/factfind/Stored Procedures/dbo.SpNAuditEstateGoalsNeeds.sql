SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEstateGoalsNeeds]
	@StampUser varchar (255),
	@EstateGoalsNeedsId bigint,
	@StampAction char(1)
AS

INSERT INTO TEstateGoalsNeedsAudit 
( CRMContactId, GoalsAndNeeds, ConcurrencyId, 
	EstateGoalsNeedsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, GoalsAndNeeds, ConcurrencyId, 
	EstateGoalsNeedsId, @StampAction, GetDate(), @StampUser
FROM TEstateGoalsNeeds
WHERE EstateGoalsNeedsId = @EstateGoalsNeedsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
