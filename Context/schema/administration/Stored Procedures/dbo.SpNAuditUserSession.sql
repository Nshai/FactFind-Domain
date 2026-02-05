SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditUserSession]
	@StampUser varchar (255),
	@UserSessionId bigint,
	@StampAction char(1)
AS

INSERT INTO TUserSessionAudit 
( UserId, SessionId, DelegateId, DelegateSessionId, 
		Sequence, IP, LastAccess, Search, 
		Recent, RecentWork, ConcurrencyId, 
	UserSessionId, StampAction, StampDateTime, StampUser) 
Select UserId, SessionId, DelegateId, DelegateSessionId, 
		Sequence, IP, LastAccess, Search, 
		Recent, RecentWork, ConcurrencyId, 
	UserSessionId, @StampAction, GetDate(), @StampUser
FROM TUserSession
WHERE UserSessionId = @UserSessionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
