SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpUpdateLifeCycleTransitionById]
@KeyLifeCycleTransitionId bigint,
@StampUser varchar (255),
@LifeCycleStepId bigint,
@ToLifeCycleStepId bigint,
@OrderNumber int = NULL,
@Type varchar (150) = NULL,
@HideStep bit = 0,
@AddToCommissionsFg tinyint = NULL
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
    'U',
    GetDate(),
    @StampUser

  FROM TLifeCycleTransition T1

  WHERE (T1.LifeCycleTransitionId = @KeyLifeCycleTransitionId)
  UPDATE T1
  SET 
    T1.LifeCycleStepId = @LifeCycleStepId,
    T1.ToLifeCycleStepId = @ToLifeCycleStepId,
    T1.OrderNumber = @OrderNumber,
    T1.Type = @Type,
    T1.HideStep = @HideStep,
    T1.AddToCommissionsFg = @AddToCommissionsFg,
    T1.ConcurrencyId = T1.ConcurrencyId + 1
  FROM TLifeCycleTransition T1

  WHERE (T1.LifeCycleTransitionId = @KeyLifeCycleTransitionId)

SELECT * FROM TLifeCycleTransition [LifeCycleTransition]
  WHERE ([LifeCycleTransition].LifeCycleTransitionId = @KeyLifeCycleTransitionId)
 FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
