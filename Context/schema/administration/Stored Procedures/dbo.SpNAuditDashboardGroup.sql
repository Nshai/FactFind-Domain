SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditDashboardGroup]
	@StampUser varchar (255),
	@DashboardGroupId uniqueidentifier,
	@StampAction char(1)
AS

INSERT INTO TDashboardGroupAudit 
( [Type], OwnerType, TenantId, UserId, ConcurrencyId, DashboardGroupId, StampAction, StampDateTime, StampUser) 
Select [Type], OwnerType, TenantId, UserId, ConcurrencyId, DashboardGroupId, @StampAction, GetDate(), @StampUser
FROM TDashboardGroup
WHERE DashboardGroupId = @DashboardGroupId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
