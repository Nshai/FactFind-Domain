SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRole]
	@StampUser varchar (255),
	@RoleId bigint,
	@StampAction char(1)
AS

INSERT INTO TRoleAudit 
( Name, ParentRoleId, IndClientId, ConcurrencyId, 
		
	RoleId, StampAction, StampDateTime, StampUser) 
Select Name, ParentRoleId, IndClientId, ConcurrencyId, 
		
	RoleId, @StampAction, GetDate(), @StampUser
FROM TRole
WHERE RoleId = @RoleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
