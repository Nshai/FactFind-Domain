SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCreateClientActivityLog]
@StampUser varchar (255),
@CRMContactId bigint,
@Activity varchar (255) = NULL,
@Application varchar (255) = NULL

AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
 
  DECLARE @ClientActivityLogId bigint

  INSERT INTO TClientActivityLog (
    CRMContactId, 
    Activity, 
    Application, 
    TimeStamp, 
    ConcurrencyId ) 
  VALUES (
    @CRMContactId, 
    @Activity, 
    @Application, 
    GetDate(), 
    1) 

  SELECT @ClientActivityLogId = SCOPE_IDENTITY()
  INSERT INTO TClientActivityLogAudit (
    CRMContactId, 
    Activity, 
    Application, 
    TimeStamp, 
    ConcurrencyId,
    ClientActivityLogId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.CRMContactId, 
    T1.Activity, 
    T1.Application, 
    T1.TimeStamp, 
    T1.ConcurrencyId,
    T1.ClientActivityLogId,
    'C',
    GetDate(),
    @StampUser

  FROM TClientActivityLog T1
 WHERE T1.ClientActivityLogId=@ClientActivityLogId
  EXEC SpRetrieveClientActivityLogById @ClientActivityLogId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
