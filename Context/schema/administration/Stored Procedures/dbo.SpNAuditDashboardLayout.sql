SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditDashboardLayout]
	@StampUser varchar (255),
	@DashboardId uniqueidentifier,
	@StampAction char(1)
AS

INSERT INTO TDashboardLayoutAudit 
( Name, Layout, TenantId, OwnerId, IsPublic, ConcurrencyId, DashboardId, StampAction, StampDateTime, StampUser) 
Select Name, Layout, TenantId, OwnerId, IsPublic, ConcurrencyId, DashboardId, @StampAction, GetDate(), @StampUser
FROM TDashboardLayout
WHERE DashboardId = @DashboardId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
