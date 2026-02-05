SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefPlanActionStatusRole]
	@StampUser varchar (255),
	@RefPlanActionStatusRoleId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPlanActionStatusRoleAudit 
( LifeCycleStepId, RefPlanActionId, RoleId, ConcurrencyId, 
		
	RefPlanActionStatusRoleId, StampAction, StampDateTime, StampUser) 
Select LifeCycleStepId, RefPlanActionId, RoleId, ConcurrencyId, 
		
	RefPlanActionStatusRoleId, @StampAction, GetDate(), @StampUser
FROM TRefPlanActionStatusRole
WHERE RefPlanActionStatusRoleId = @RefPlanActionStatusRoleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
