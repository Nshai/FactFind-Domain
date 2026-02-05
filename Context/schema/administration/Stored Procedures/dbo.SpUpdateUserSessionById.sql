SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpUpdateUserSessionById]
@KeyUserSessionId bigint,
@StampUser varchar (255),
@UserId bigint,
@SessionId varchar (128) = NULL,
@DelegateId bigint = NULL,
@DelegateSessionId varchar (128) = NULL,
@Sequence int = 0,
@IP varchar (16) = NULL,
@LastAccess datetime = NULL,
@Search text = NULL,
@Recent text = NULL,
@RecentWork text = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TUserSessionAudit (
    UserId, 
    SessionId, 
    DelegateId, 
    DelegateSessionId, 
    Sequence, 
    IP, 
    LastAccess, 
    Search, 
    Recent, 
    RecentWork, 
    ConcurrencyId,
    UserSessionId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.UserId, 
    T1.SessionId, 
    T1.DelegateId, 
    T1.DelegateSessionId, 
    T1.Sequence, 
    T1.IP, 
    T1.LastAccess, 
    T1.Search, 
    T1.Recent, 
    T1.RecentWork, 
    T1.ConcurrencyId,
    T1.UserSessionId,
    'U',
    GetDate(),
    @StampUser

  FROM TUserSession T1

  WHERE (T1.UserSessionId = @KeyUserSessionId)
  UPDATE T1
  SET 
    T1.UserId = @UserId,
    T1.SessionId = @SessionId,
    T1.DelegateId = @DelegateId,
    T1.DelegateSessionId = @DelegateSessionId,
    T1.Sequence = @Sequence,
    T1.IP = @IP,
    T1.LastAccess = @LastAccess,
    T1.Search = @Search,
    T1.Recent = @Recent,
    T1.RecentWork = @RecentWork,
    T1.ConcurrencyId = T1.ConcurrencyId + 1
  FROM TUserSession T1

  WHERE (T1.UserSessionId = @KeyUserSessionId)

SELECT * FROM TUserSession [UserSession]
  WHERE ([UserSession].UserSessionId = @KeyUserSessionId)
 FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
