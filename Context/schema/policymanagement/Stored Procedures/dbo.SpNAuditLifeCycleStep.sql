SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLifeCycleStep]
	@StampUser varchar (255),
	@LifeCycleStepId bigint,
	@StampAction char(1)
AS

INSERT INTO TLifeCycleStepAudit 
( StatusId, LifeCycleId, ConcurrencyId, 
	LifeCycleStepId, StampAction, StampDateTime, StampUser, IsSystem) 
Select StatusId, LifeCycleId, ConcurrencyId, 
	LifeCycleStepId, @StampAction, GetDate(), @StampUser, IsSystem
FROM TLifeCycleStep
WHERE LifeCycleStepId = @LifeCycleStepId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
