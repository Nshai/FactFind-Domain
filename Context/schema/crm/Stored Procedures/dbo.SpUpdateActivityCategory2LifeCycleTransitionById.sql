SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpUpdateActivityCategory2LifeCycleTransitionById]
@KeyActivityCategory2LifeCycleTransitionId bigint,
@StampUser varchar (255),
@LifeCycleTransitionId bigint,
@ActivityCategoryId bigint,
@CheckOutcome int = 0,
@CheckDueDate int = 0
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TActivityCategory2LifeCycleTransitionAudit (
    LifeCycleTransitionId, 
    ActivityCategoryId, 
    CheckOutcome, 
    CheckDueDate, 
    ConcurrencyId,
    ActivityCategory2LifeCycleTransitionId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.LifeCycleTransitionId, 
    T1.ActivityCategoryId, 
    T1.CheckOutcome, 
    T1.CheckDueDate, 
    T1.ConcurrencyId,
    T1.ActivityCategory2LifeCycleTransitionId,
    'U',
    GetDate(),
    @StampUser

  FROM TActivityCategory2LifeCycleTransition T1

  WHERE (T1.ActivityCategory2LifeCycleTransitionId = @KeyActivityCategory2LifeCycleTransitionId)
  UPDATE T1
  SET 
    T1.LifeCycleTransitionId = @LifeCycleTransitionId,
    T1.ActivityCategoryId = @ActivityCategoryId,
    T1.CheckOutcome = @CheckOutcome,
    T1.CheckDueDate = @CheckDueDate,
    T1.ConcurrencyId = T1.ConcurrencyId + 1
  FROM TActivityCategory2LifeCycleTransition T1

  WHERE (T1.ActivityCategory2LifeCycleTransitionId = @KeyActivityCategory2LifeCycleTransitionId)

SELECT * FROM TActivityCategory2LifeCycleTransition [ActivityCategory2LifeCycleTransition]
  WHERE ([ActivityCategory2LifeCycleTransition].ActivityCategory2LifeCycleTransitionId = @KeyActivityCategory2LifeCycleTransitionId)
 FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
