SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateLifeCycleStep]
@StampUser varchar (255),
@StatusId bigint,
@LifeCycleId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @LifeCycleStepId bigint

  INSERT INTO TLifeCycleStep (
    StatusId, 
    LifeCycleId, 
    ConcurrencyId ) 
  VALUES (
    @StatusId, 
    @LifeCycleId, 
    1) 

  SELECT @LifeCycleStepId = SCOPE_IDENTITY()
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
    'C',
    GetDate(),
    @StampUser

  FROM TLifeCycleStep T1
 WHERE T1.LifeCycleStepId=@LifeCycleStepId
  EXEC SpRetrieveLifeCycleStepById @LifeCycleStepId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
