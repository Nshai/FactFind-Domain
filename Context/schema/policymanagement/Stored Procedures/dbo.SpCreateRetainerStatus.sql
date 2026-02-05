SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateRetainerStatus]
@StampUser varchar (255),
@RetainerId bigint,
@Status varchar (50),
@StatusNotes varchar (250) = NULL,
@StatusDate datetime,
@UpdatedUserId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @RetainerStatusId bigint

  INSERT INTO TRetainerStatus (
    RetainerId, 
    Status, 
    StatusNotes, 
    StatusDate, 
    UpdatedUserId, 
    ConcurrencyId ) 
  VALUES (
    @RetainerId, 
    @Status, 
    @StatusNotes, 
    @StatusDate, 
    @UpdatedUserId, 
    1) 

  SELECT @RetainerStatusId = SCOPE_IDENTITY()
  INSERT INTO TRetainerStatusAudit (
    RetainerId, 
    Status, 
    StatusNotes, 
    StatusDate, 
    UpdatedUserId, 
    ConcurrencyId,
    RetainerStatusId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.RetainerId, 
    T1.Status, 
    T1.StatusNotes, 
    T1.StatusDate, 
    T1.UpdatedUserId, 
    T1.ConcurrencyId,
    T1.RetainerStatusId,
    'C',
    GetDate(),
    @StampUser

  FROM TRetainerStatus T1
 WHERE T1.RetainerStatusId=@RetainerStatusId
  EXEC SpRetrieveRetainerStatusById @RetainerStatusId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)



GO
