SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValRequestSubPlan]
	@StampUser varchar (255),
	@ValRequestSubPlanId bigint,
	@StampAction char(1)
AS

INSERT INTO TValRequestSubPlanAudit 
( PolicyBusinessId, ValRequestId, PlanValuationId, 		
		ConcurrencyId, 
	ValRequestSubPlanId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, ValRequestId, PlanValuationId, 
		ConcurrencyId, 
	ValRequestSubPlanId, @StampAction, GetDate(), @StampUser
FROM TValRequestSubPlan
WHERE ValRequestSubPlanId = @ValRequestSubPlanId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
