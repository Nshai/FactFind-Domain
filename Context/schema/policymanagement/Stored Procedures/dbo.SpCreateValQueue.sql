SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateValQueue]
@StampUser varchar (255),
@Guid varchar (50),
@PolicyBusinessId bigint,
@Status varchar (255),
@ValRequestId bigint = NULL,
@StartTime datetime = NULL,
@EndTime datetime = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  IF @StartTime IS NULL SET @StartTime = getdate()
  DECLARE @ValQueueId bigint

  INSERT INTO TValQueue (
    Guid, 
    PolicyBusinessId, 
    Status, 
    ValRequestId, 
    StartTime, 
    EndTime, 
    ConcurrencyId ) 
  VALUES (
    @Guid, 
    @PolicyBusinessId, 
    @Status, 
    @ValRequestId, 
    @StartTime, 
    @EndTime, 
    1) 

  SELECT @ValQueueId = SCOPE_IDENTITY()
  INSERT INTO TValQueueAudit (
    Guid, 
    PolicyBusinessId, 
    Status, 
    ValRequestId, 
    StartTime, 
    EndTime, 
    ConcurrencyId,
    ValQueueId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.Guid, 
    T1.PolicyBusinessId, 
    T1.Status, 
    T1.ValRequestId, 
    T1.StartTime, 
    T1.EndTime, 
    T1.ConcurrencyId,
    T1.ValQueueId,
    'C',
    GetDate(),
    @StampUser

  FROM TValQueue T1
 WHERE T1.ValQueueId=@ValQueueId
  EXEC SpRetrieveValQueueById @ValQueueId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
