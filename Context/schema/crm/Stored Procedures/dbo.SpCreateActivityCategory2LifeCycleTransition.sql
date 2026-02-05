SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateActivityCategory2LifeCycleTransition]
@StampUser varchar (255),
@LifeCycleTransitionId bigint,
@ActivityCategoryId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @ActivityCategory2LifeCycleTransitionId bigint

  INSERT INTO TActivityCategory2LifeCycleTransition (
    LifeCycleTransitionId, 
    ActivityCategoryId, 
    ConcurrencyId ) 
  VALUES (
    @LifeCycleTransitionId, 
    @ActivityCategoryId, 
    1) 

  SELECT @ActivityCategory2LifeCycleTransitionId = SCOPE_IDENTITY()
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
    'C',
    GetDate(),
    @StampUser

  FROM TActivityCategory2LifeCycleTransition T1
 WHERE T1.ActivityCategory2LifeCycleTransitionId=@ActivityCategory2LifeCycleTransitionId
  EXEC SpRetrieveActivityCategory2LifeCycleTransitionById @ActivityCategory2LifeCycleTransitionId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
