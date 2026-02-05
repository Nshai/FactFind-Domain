SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAdviceCaseStatusChangeRole]
	@StampUser varchar (255),
	@AdviceCaseStatusChangeRoleId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCaseStatusChangeRoleAudit 
( AdviceCaseStatusChangeId, RoleId, ConcurrencyId, 
	AdviceCaseStatusChangeRoleId, StampAction, StampDateTime, StampUser) 
Select AdviceCaseStatusChangeId, RoleId, ConcurrencyId, 
	AdviceCaseStatusChangeRoleId, @StampAction, GetDate(), @StampUser
FROM TAdviceCaseStatusChangeRole
WHERE AdviceCaseStatusChangeRoleId = @AdviceCaseStatusChangeRoleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
