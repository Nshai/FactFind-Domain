SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditActivityCategory2LifeCycleStep]
	@StampUser varchar (255),
	@ActivityCategory2LifeCycleStepId bigint,
	@StampAction char(1)
AS

INSERT INTO TActivityCategory2LifeCycleStepAudit 
( LifeCycleStepId, ActivityCategoryId, ConcurrencyId, 
	ActivityCategory2LifeCycleStepId, StampAction, StampDateTime, StampUser) 
Select LifeCycleStepId, ActivityCategoryId, ConcurrencyId, 
	ActivityCategory2LifeCycleStepId, @StampAction, GetDate(), @StampUser
FROM TActivityCategory2LifeCycleStep
WHERE ActivityCategory2LifeCycleStepId = @ActivityCategory2LifeCycleStepId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
