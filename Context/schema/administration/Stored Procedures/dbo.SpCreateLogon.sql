SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateLogon]
@StampUser varchar (255),
@UserId bigint,
@LogonDateTime datetime,
@LogoffDateTime datetime = NULL,
@Type varchar (20),
@SourceAddress varchar (50) = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @LogonId bigint

  INSERT INTO TLogon (
    UserId, 
    LogonDateTime, 
    LogoffDateTime, 
    Type, 
    SourceAddress, 
    ConcurrencyId ) 
  VALUES (
    @UserId, 
    @LogonDateTime, 
    @LogoffDateTime, 
    @Type, 
    @SourceAddress, 
    1) 

  SELECT @LogonId = SCOPE_IDENTITY()
  INSERT INTO TLogonAudit (
    UserId, 
    LogonDateTime, 
    LogoffDateTime, 
    Type, 
    SourceAddress, 
    ConcurrencyId,
    LogonId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.UserId, 
    T1.LogonDateTime, 
    T1.LogoffDateTime, 
    T1.Type, 
    T1.SourceAddress, 
    T1.ConcurrencyId,
    T1.LogonId,
    'C',
    GetDate(),
    @StampUser

  FROM TLogon T1
 WHERE T1.LogonId=@LogonId
  EXEC SpRetrieveLogonById @LogonId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
