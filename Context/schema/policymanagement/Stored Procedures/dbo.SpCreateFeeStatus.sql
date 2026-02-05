SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateFeeStatus]
@StampUser varchar (255),
@FeeId bigint,
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
  DECLARE @FeeStatusId bigint

  INSERT INTO TFeeStatus (
    FeeId, 
    Status, 
    StatusNotes, 
    StatusDate, 
    UpdatedUserId, 
    ConcurrencyId ) 
  VALUES (
    @FeeId, 
    @Status, 
    @StatusNotes, 
    @StatusDate, 
    @UpdatedUserId, 
    1) 

  SELECT @FeeStatusId = SCOPE_IDENTITY()
  INSERT INTO TFeeStatusAudit (
    FeeId, 
    Status, 
    StatusNotes, 
    StatusDate, 
    UpdatedUserId, 
    ConcurrencyId,
    FeeStatusId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.FeeId, 
    T1.Status, 
    T1.StatusNotes, 
    T1.StatusDate, 
    T1.UpdatedUserId, 
    T1.ConcurrencyId,
    T1.FeeStatusId,
    'C',
    GetDate(),
    @StampUser

  FROM TFeeStatus T1
 WHERE T1.FeeStatusId=@FeeStatusId
  EXEC SpRetrieveFeeStatusById @FeeStatusId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
