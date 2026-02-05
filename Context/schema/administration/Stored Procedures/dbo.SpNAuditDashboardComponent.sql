SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditDashboardComponent]
	@StampUser varchar (255),
	@DashboardComponentId bigint,
	@StampAction char(1)
AS

INSERT INTO TDashboardComponentAudit 
( Identifier, Description, ConcurrencyId, 
		
	DashboardComponentId, StampAction, StampDateTime, StampUser) 
Select Identifier, Description, ConcurrencyId, 
		
	DashboardComponentId, @StampAction, GetDate(), @StampUser
FROM TDashboardComponent
WHERE DashboardComponentId = @DashboardComponentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
