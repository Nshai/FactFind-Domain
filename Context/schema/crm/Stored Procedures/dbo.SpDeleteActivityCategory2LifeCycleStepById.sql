SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDeleteActivityCategory2LifeCycleStepById]
	@ActivityCategory2LifeCycleStepId Bigint,
	@StampUser varchar (255)
	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	INSERT INTO TActivityCategory2LifeCycleStepAudit (
		LifeCycleStepId, 
		ActivityCategoryId, 
		ConcurrencyId,
		ActivityCategory2LifeCycleStepId,
		StampAction,
    		StampDateTime,
    		StampUser)
		
	SELECT 
		T1.LifeCycleStepId, 
		T1.ActivityCategoryId, 
		T1.ConcurrencyId,
		T1.ActivityCategory2LifeCycleStepId,
		'D',
    		GetDate(),
    		@StampUser 
	FROM TActivityCategory2LifeCycleStep T1	
	WHERE T1.ActivityCategory2LifeCycleStepId = @ActivityCategory2LifeCycleStepId

	DELETE T1 FROM TActivityCategory2LifeCycleStep T1
	WHERE T1.ActivityCategory2LifeCycleStepId = @ActivityCategory2LifeCycleStepId

	SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
