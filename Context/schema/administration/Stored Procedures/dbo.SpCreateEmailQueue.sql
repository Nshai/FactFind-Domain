SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateEmailQueue]
@StampUser varchar (255),
@IndigoClientId bigint,
@OwnerId bigint = NULL,
@QueueDescription varchar (255),
@Subject varchar (255) = NULL,
@StatusId bigint = NULL,
@ToAddress varchar (255) = NULL,
@FromAddress varchar (255) = NULL,
@CcAddress varchar (255) = NULL,
@BccAddress varchar (255) = NULL,
@Body text = NULL,
@PreMergedFg bit = 0,
@Guid varchar (255) = NULL,
@MergeData text = NULL,
@AddedDate datetime = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  IF @AddedDate IS NULL SET @AddedDate = getdate()
  DECLARE @EmailQueueId bigint

  INSERT INTO TEmailQueue (
    IndigoClientId, 
    OwnerId, 
    QueueDescription, 
    Subject, 
    StatusId, 
    ToAddress, 
    FromAddress, 
    CcAddress, 
    BccAddress, 
    Body, 
    PreMergedFg, 
    Guid, 
    MergeData, 
    AddedDate, 
    ConcurrencyId ) 
  VALUES (
    @IndigoClientId, 
    @OwnerId, 
    @QueueDescription, 
    @Subject, 
    @StatusId, 
    @ToAddress, 
    @FromAddress, 
    @CcAddress, 
    @BccAddress, 
    @Body, 
    @PreMergedFg, 
    @Guid, 
    @MergeData, 
    @AddedDate, 
    1) 

  SELECT @EmailQueueId = SCOPE_IDENTITY()
  INSERT INTO TEmailQueueAudit (
    IndigoClientId, 
    OwnerId, 
    QueueDescription, 
    Subject, 
    StatusId, 
    ToAddress, 
    FromAddress, 
    CcAddress, 
    BccAddress, 
    Body, 
    PreMergedFg, 
    Guid, 
    MergeData, 
    AddedDate, 
    ConcurrencyId,
    EmailQueueId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.IndigoClientId, 
    T1.OwnerId, 
    T1.QueueDescription, 
    T1.Subject, 
    T1.StatusId, 
    T1.ToAddress, 
    T1.FromAddress, 
    T1.CcAddress, 
    T1.BccAddress, 
    T1.Body, 
    T1.PreMergedFg, 
    T1.Guid, 
    T1.MergeData, 
    T1.AddedDate, 
    T1.ConcurrencyId,
    T1.EmailQueueId,
    'C',
    GetDate(),
    @StampUser

  FROM TEmailQueue T1
 WHERE T1.EmailQueueId=@EmailQueueId
  EXEC SpRetrieveEmailQueueById @EmailQueueId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
