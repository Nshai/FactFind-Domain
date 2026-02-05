SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditTransitionRole]
	@StampUser varchar (255),
	@TransitionRoleId bigint,
	@StampAction char(1)
AS

INSERT INTO TTransitionRoleAudit 
( RoleId, LifeCycleTransitionId, ConcurrencyId, 
	TransitionRoleId, StampAction, StampDateTime, StampUser) 
Select RoleId, LifeCycleTransitionId, ConcurrencyId, 
	TransitionRoleId, @StampAction, GetDate(), @StampUser
FROM TTransitionRole
WHERE TransitionRoleId = @TransitionRoleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
