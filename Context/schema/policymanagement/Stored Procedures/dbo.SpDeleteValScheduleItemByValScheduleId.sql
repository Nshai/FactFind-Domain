SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpDeleteValScheduleItemByValScheduleId]
@ValScheduleId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TValScheduleItemAudit (
    ValScheduleId, 
    ValQueueId, 
    NextOccurrence, 
    LastOccurrence, 
    ConcurrencyId,
    ValScheduleItemId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.ValScheduleId, 
    T1.ValQueueId, 
    T1.NextOccurrence, 
    T1.LastOccurrence, 
    T1.ConcurrencyId,
    T1.ValScheduleItemId,
    'D',
    GetDate(),
    @StampUser

  FROM TValScheduleItem T1

  WHERE (T1.ValScheduleId = @ValScheduleId)
  DELETE T1 FROM TValScheduleItem T1

  WHERE (T1.ValScheduleId = @ValScheduleId)


  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
