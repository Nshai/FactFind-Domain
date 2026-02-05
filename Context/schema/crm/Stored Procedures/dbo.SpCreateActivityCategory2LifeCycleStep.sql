SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateActivityCategory2LifeCycleStep]
	@StampUser varchar (255),
	@LifeCycleStepId bigint, 
	@ActivityCategoryId bigint	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @ActivityCategory2LifeCycleStepId bigint
			
	
	INSERT INTO TActivityCategory2LifeCycleStep (
		LifeCycleStepId, 
		ActivityCategoryId, 
		ConcurrencyId)
		
	VALUES(
		@LifeCycleStepId, 
		@ActivityCategoryId,
		1)

	SELECT @ActivityCategory2LifeCycleStepId = SCOPE_IDENTITY()
	
	INSERT INTO TActivityCategory2LifeCycleStepAudit (
		LifeCycleStepId, 
		ActivityCategoryId, 
		ConcurrencyId,
		ActivityCategory2LifeCycleStepId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		LifeCycleStepId, 
		ActivityCategoryId, 
		ConcurrencyId,
		ActivityCategory2LifeCycleStepId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TActivityCategory2LifeCycleStep
	WHERE ActivityCategory2LifeCycleStepId = @ActivityCategory2LifeCycleStepId
	EXEC SpRetrieveActivityCategory2LifeCycleStepById @ActivityCategory2LifeCycleStepId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
