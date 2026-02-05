SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[SpNAuditDashboardGroupLayout]
	@StampUser varchar (255),
	@DashboardGroupId uniqueidentifier,
	@StampAction char(1)
AS

INSERT INTO TDashboardGroupLayoutAudit 
( DashboardGroupId, DashboardId, DisplayOrder, StampAction, StampDateTime, StampUser) 
Select DashboardGroupId, DashboardId, DisplayOrder, @StampAction, GetDate(), @StampUser
FROM TDashboardGroupLayout
WHERE DashboardGroupId = @DashboardGroupId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
