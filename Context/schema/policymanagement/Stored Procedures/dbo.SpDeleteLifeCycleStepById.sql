SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpDeleteLifeCycleStepById]
@LifeCycleStepId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TLifeCycleStepAudit (
    StatusId, 
    LifeCycleId, 
    ConcurrencyId,
    LifeCycleStepId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.StatusId, 
    T1.LifeCycleId, 
    T1.ConcurrencyId,
    T1.LifeCycleStepId,
    'D',
    GetDate(),
    @StampUser

  FROM TLifeCycleStep T1

  WHERE (T1.LifeCycleStepId = @LifeCycleStepId)
  DELETE T1 FROM TLifeCycleStep T1

  WHERE (T1.LifeCycleStepId = @LifeCycleStepId)


  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
