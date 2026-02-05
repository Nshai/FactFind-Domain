SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpDeleteActivityCategory2LifeCycleTransitionById]
@ActivityCategory2LifeCycleTransitionId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TActivityCategory2LifeCycleTransitionAudit (
    LifeCycleTransitionId, 
    ActivityCategoryId, 
    ConcurrencyId,
    ActivityCategory2LifeCycleTransitionId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.LifeCycleTransitionId, 
    T1.ActivityCategoryId, 
    T1.ConcurrencyId,
    T1.ActivityCategory2LifeCycleTransitionId,
    'D',
    GetDate(),
    @StampUser

  FROM TActivityCategory2LifeCycleTransition T1

  WHERE (T1.ActivityCategory2LifeCycleTransitionId = @ActivityCategory2LifeCycleTransitionId)
  DELETE T1 FROM TActivityCategory2LifeCycleTransition T1

  WHERE (T1.ActivityCategory2LifeCycleTransitionId = @ActivityCategory2LifeCycleTransitionId)


  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
