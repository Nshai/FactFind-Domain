SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditDashboardPermissions]
	@StampUser varchar (255),
	@DashboardPermissionsId bigint,
	@StampAction char(1)
AS

INSERT INTO TDashboardPermissionsAudit 
( DashboardId, RoleId, isAllowed, ConcurrencyId, 
	DashboardPermissionsId, StampAction, StampDateTime, StampUser) 
Select DashboardId, RoleId, isAllowed, ConcurrencyId, 
	DashboardPermissionsId, @StampAction, GetDate(), @StampUser
FROM TDashboardPermissions
WHERE DashboardPermissionsId = @DashboardPermissionsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
