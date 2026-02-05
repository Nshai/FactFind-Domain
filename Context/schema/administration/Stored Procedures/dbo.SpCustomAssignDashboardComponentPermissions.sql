SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomAssignDashboardComponentPermissions]        
@DashboardComponentId bigint,        
@RoleId bigint,
@IsAllowed tinyint,
@StampUser varchar(50)
AS        
        

DECLARE @DashboardComponentPermissionsId bigint
SELECT @DashboardComponentPermissionsId=DashboardComponentPermissionsId FROM TDashboardComponentPermissions WHERE RoleId=@RoleId AND DashboardComponentId=@DashboardComponentId

IF ISNULL(@DashboardComponentPermissionsId,0)=0
BEGIN
	INSERT TDashboardComponentPermissions(DashboardComponentId,RoleId,isAllowed,ConcurrencyId)
	SELECT @DashboardComponentId,@RoleId,@IsAllowed,1

	SELECT @DashboardComponentPermissionsId=SCOPE_IDENTITY()
	INSERT TDashboardComponentPermissionsAudit(DashboardComponentId,RoleId,isAllowed,ConcurrencyId,DashboardComponentPermissionsId,StampAction,StampDateTime,StampUser)
	SELECT DashboardComponentId,RoleId,isAllowed,ConcurrencyId,DashboardComponentPermissionsId,'C',getdate(),@StampUser
	FROM TDashboardComponentPermissions
	WHERE DashboardComponentPermissionsId=@DashboardComponentPermissionsId

END
ELSE
BEGIN
	INSERT TDashboardComponentPermissionsAudit(DashboardComponentId,RoleId,isAllowed,ConcurrencyId,DashboardComponentPermissionsId,StampAction,StampDateTime,StampUser)
	SELECT DashboardComponentId,RoleId,isAllowed,ConcurrencyId,DashboardComponentPermissionsId,'U',getdate(),@StampUser
	FROM TDashboardComponentPermissions
	WHERE DashboardComponentPermissionsId=@DashboardComponentPermissionsId

	
	Update  TDashboardComponentPermissions
	SET IsAllowed=@IsAllowed
	WHERE DashboardComponentPermissionsId=@DashboardComponentPermissionsId
END

RETURN(0)

GO
