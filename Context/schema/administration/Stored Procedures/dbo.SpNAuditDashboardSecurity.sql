SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditDashboardSecurity]
	@StampUser varchar (255),
	@DashboardSecurityId bigint,
	@StampAction char(1)
AS

INSERT INTO TDashboardSecurityAudit 
( DashboardComponentId, RoleId, isAllowed, ConcurrencyId, 
		
	DashboardSecurityId, StampAction, StampDateTime, StampUser) 
Select DashboardComponentId, RoleId, isAllowed, ConcurrencyId, 
		
	DashboardSecurityId, @StampAction, GetDate(), @StampUser
FROM TDashboardSecurity
WHERE DashboardSecurityId = @DashboardSecurityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
