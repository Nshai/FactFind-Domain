SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[nio_SpCustomAssignDashboardComponentPermissions]
@DashboardComponentId bigint,        
@RoleId bigint,
@IsAllowed bit,
@StampUser varchar(50)
as

BEGIN

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

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

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
SELECT 0

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  SELECT 1

GO
