SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditUserGroup]
	@StampUser VARCHAR(255),
	@UserGroupId INT,
	@StampAction CHAR(1)
AS

	INSERT INTO TUserGroupAudit (UserGroupId, UserId, GroupId, RoleId, ConcurrencyId, StampAction, StampDateTime, StampUser) 
	SELECT UserGroupId, UserId, GroupId, RoleId, ConcurrencyId, @StampAction, GetDate(), @StampUser
	FROM TUserGroup
	WHERE UserGroupId = @UserGroupId

	IF @@ERROR != 0 
		GOTO errh
	RETURN (0)

errh:
	RETURN (100)

GO