SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditActivityCategory2LifeCycleTransition]
	@StampUser varchar (255),
	@ActivityCategory2LifeCycleTransitionId bigint,
	@StampAction char(1)
AS

INSERT INTO TActivityCategory2LifeCycleTransitionAudit 
( LifeCycleTransitionId, ActivityCategoryId, ConcurrencyId, 
	ActivityCategory2LifeCycleTransitionId, StampAction, StampDateTime, StampUser) 
Select LifeCycleTransitionId, ActivityCategoryId, ConcurrencyId, 
	ActivityCategory2LifeCycleTransitionId, @StampAction, GetDate(), @StampUser
FROM TActivityCategory2LifeCycleTransition
WHERE ActivityCategory2LifeCycleTransitionId = @ActivityCategory2LifeCycleTransitionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
