SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION dbo.fnGetRolesForUser(@UserId bigint, @ExcludeRoleId bigint)
	RETURNS VARCHAR(8000) AS
	
	BEGIN
	   DECLARE @RoleList varchar(1000)
	
	   SELECT @RoleList = COALESCE(@RoleList + ', ', '') + r.Identifier
	
	   FROM TRole r
	   INNER JOIN TMembership m ON m.RoleId = r.RoleId
	   WHERE m.UserId = @UserId
	   AND (@ExcludeRoleId = 0 OR r.RoleId <> @ExcludeRoleId)
	
	   RETURN @RoleList
	END
GO
