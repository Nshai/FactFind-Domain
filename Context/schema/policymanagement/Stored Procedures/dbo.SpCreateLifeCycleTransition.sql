SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateLifeCycleTransition]
	@StampUser varchar (255),
	@LifeCycleStepId bigint, 
	@ToLifeCycleStepId bigint, 
	@OrderNumber int = NULL, 
	@Type varchar(150)  = NULL, 
	@HideStep bit = 0, 
	@AddToCommissionsFg tinyint = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @LifeCycleTransitionId bigint
			
	
	INSERT INTO TLifeCycleTransition (
		LifeCycleStepId, 
		ToLifeCycleStepId, 
		OrderNumber, 
		Type, 
		HideStep, 
		AddToCommissionsFg, 
		ConcurrencyId)
		
	VALUES(
		@LifeCycleStepId, 
		@ToLifeCycleStepId, 
		@OrderNumber, 
		@Type, 
		@HideStep, 
		@AddToCommissionsFg,
		1)

	SELECT @LifeCycleTransitionId = SCOPE_IDENTITY()

	INSERT INTO TLifeCycleTransitionAudit (
		LifeCycleStepId, 
		ToLifeCycleStepId, 
		OrderNumber, 
		Type, 
		HideStep, 
		AddToCommissionsFg, 
		ConcurrencyId,
		LifeCycleTransitionId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		LifeCycleStepId, 
		ToLifeCycleStepId, 
		OrderNumber, 
		Type, 
		HideStep, 
		AddToCommissionsFg, 
		ConcurrencyId,
		LifeCycleTransitionId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TLifeCycleTransition
	WHERE LifeCycleTransitionId = @LifeCycleTransitionId

	EXEC SpRetrieveLifeCycleTransitionById @LifeCycleTransitionId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
