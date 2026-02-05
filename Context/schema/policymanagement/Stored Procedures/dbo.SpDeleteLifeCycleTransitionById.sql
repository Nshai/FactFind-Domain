SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDeleteLifeCycleTransitionById]
	@LifeCycleTransitionId Bigint,
	@StampUser varchar (255)
	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN

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
		T1.LifeCycleStepId, 
		T1.ToLifeCycleStepId, 
		T1.OrderNumber, 
		T1.Type, 
		T1.HideStep, 
		T1.AddToCommissionsFg, 
		T1.ConcurrencyId,
		T1.LifeCycleTransitionId,
		'D',
    		GetDate(),
    		@StampUser 
	FROM TLifeCycleTransition T1	
	WHERE T1.LifeCycleTransitionId = @LifeCycleTransitionId

	DELETE T1 FROM TLifeCycleTransition T1
	WHERE T1.LifeCycleTransitionId = @LifeCycleTransitionId

	SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
