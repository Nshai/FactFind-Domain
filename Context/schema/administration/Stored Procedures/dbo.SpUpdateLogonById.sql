SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpUpdateLogonById]
@KeyLogonId bigint,
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
    'U',
    GetDate(),
    @StampUser

  FROM TLogon T1

  WHERE (T1.LogonId = @KeyLogonId)
  UPDATE T1
  SET 
    T1.UserId = @UserId,
    T1.LogonDateTime = @LogonDateTime,
    T1.LogoffDateTime = @LogoffDateTime,
    T1.Type = @Type,
    T1.SourceAddress = @SourceAddress,
    T1.ConcurrencyId = T1.ConcurrencyId + 1
  FROM TLogon T1

  WHERE (T1.LogonId = @KeyLogonId)

SELECT * FROM TLogon [Logon]
  WHERE ([Logon].LogonId = @KeyLogonId)
 FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
