SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpUpdateValScheduleItemByValScheduleId]
@KeyValScheduleId bigint,
@StampUser varchar (255),
@ValScheduleId bigint,
@ValQueueId bigint = NULL,
@NextOccurrence datetime = NULL,
@LastOccurrence datetime = NULL,
@ErrorMessage varchar (2000) = NULL,
@RefValScheduleItemStatusId bigint = NULL,
@SaveAsFilePathAndName varchar (255) = NULL,
@DocVersionID BIGINT = 0
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
    ErrorMessage, 
    RefValScheduleItemStatusId, 
    SaveAsFilePathAndName, 
    Docversionid,
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
    T1.ErrorMessage, 
    T1.RefValScheduleItemStatusId, 
    T1.SaveAsFilePathAndName, 
    T1.Docversionid,
    T1.ConcurrencyId,
    T1.ValScheduleItemId,
    'U',
    GetDate(),
    @StampUser

  FROM TValScheduleItem T1

  WHERE (T1.ValScheduleId = @KeyValScheduleId)
  UPDATE T1
  SET 
    T1.ValScheduleId = @ValScheduleId,
    T1.ValQueueId = @ValQueueId,
    T1.NextOccurrence = @NextOccurrence,
    T1.LastOccurrence = @LastOccurrence,
    T1.ErrorMessage = @ErrorMessage,
    T1.RefValScheduleItemStatusId = @RefValScheduleItemStatusId,
    T1.SaveAsFilePathAndName = @SaveAsFilePathAndName,
    T1.DocVersionId = @DocVersionID,
    T1.ConcurrencyId = T1.ConcurrencyId + 1
  FROM TValScheduleItem T1

  WHERE (T1.ValScheduleId = @KeyValScheduleId)

SELECT * FROM TValScheduleItem [ValScheduleItem]
  WHERE ([ValScheduleItem].ValScheduleId = @KeyValScheduleId)
 FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
