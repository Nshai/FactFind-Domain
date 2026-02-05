SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditDashboardComponentPermissions]
	@StampUser varchar (255),
	@DashboardComponentPermissionsId bigint,
	@StampAction char(1)
AS

INSERT INTO TDashboardComponentPermissionsAudit 
([DashboardComponentId],[RoleId],[isAllowed],[ConcurrencyId],[DashboardComponentPermissionsId],[StampAction],[StampDateTime],[StampUser])
SELECT
[DashboardComponentId],[RoleId],[isAllowed],[ConcurrencyId],[DashboardComponentPermissionsId],@StampAction, GetDate(), @StampUser
FROM TDashboardComponentPermissions
WHERE DashboardComponentPermissionsId = @DashboardComponentPermissionsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
