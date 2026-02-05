SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpUpdateLifeCycleById]
@KeyLifeCycleId bigint,
@StampUser varchar (255),
@Name varchar (100),
@Descriptor varchar (255) = NULL,
@Status int = 0,
@PreQueueBehaviour varchar (150) = NULL,
@PostQueueBehaviour varchar (150) = NULL,
@CreatedDate datetime = NULL,
@CreatedUser bigint = NULL,
@IndigoClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TLifeCycleAudit (
    Name, 
    Descriptor, 
    Status, 
    PreQueueBehaviour, 
    PostQueueBehaviour, 
    CreatedDate, 
    CreatedUser, 
    IndigoClientId, 
    ConcurrencyId,
    LifeCycleId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.Name, 
    T1.Descriptor, 
    T1.Status, 
    T1.PreQueueBehaviour, 
    T1.PostQueueBehaviour, 
    T1.CreatedDate, 
    T1.CreatedUser, 
    T1.IndigoClientId, 
    T1.ConcurrencyId,
    T1.LifeCycleId,
    'U',
    GetDate(),
    @StampUser

  FROM TLifeCycle T1

  WHERE (T1.LifeCycleId = @KeyLifeCycleId)
  UPDATE T1
  SET 
    T1.Name = @Name,
    T1.Descriptor = @Descriptor,
    T1.Status = @Status,
    T1.PreQueueBehaviour = @PreQueueBehaviour,
    T1.PostQueueBehaviour = @PostQueueBehaviour,
    T1.CreatedDate = @CreatedDate,
    T1.CreatedUser = @CreatedUser,
    T1.IndigoClientId = @IndigoClientId,
    T1.ConcurrencyId = T1.ConcurrencyId + 1
  FROM TLifeCycle T1

  WHERE (T1.LifeCycleId = @KeyLifeCycleId)

SELECT * FROM TLifeCycle [LifeCycle]
  WHERE ([LifeCycle].LifeCycleId = @KeyLifeCycleId)
 FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
