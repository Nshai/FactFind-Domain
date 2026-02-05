SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditDashboardComponentItem]
	@StampUser varchar (255),
	@DashboardComponentItemId bigint,
	@StampAction char(1)
AS

INSERT INTO TDashboardComponentItemAudit 
( DashboardComponentId, TenantId, ItemName, Description, 
		Value, ConcurrencyId, 
	DashboardComponentItemId, StampAction, StampDateTime, StampUser) 
Select DashboardComponentId, TenantId, ItemName, Description, 
		Value, ConcurrencyId, 
	DashboardComponentItemId, @StampAction, GetDate(), @StampUser
FROM TDashboardComponentItem
WHERE DashboardComponentItemId = @DashboardComponentItemId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
