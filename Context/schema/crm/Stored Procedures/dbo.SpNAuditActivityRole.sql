SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditActivityRole]
	@StampUser varchar (255),
	@ActivityRoleId bigint,
	@StampAction char(1)
AS

INSERT INTO TActivityRoleAudit 
( EventListTemplateActivityId, RoleId, ConcurrencyId, 
	ActivityRoleId, StampAction, StampDateTime, StampUser) 
Select EventListTemplateActivityId, RoleId, ConcurrencyId, 
	ActivityRoleId, @StampAction, GetDate(), @StampUser
FROM TActivityRole
WHERE ActivityRoleId = @ActivityRoleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
