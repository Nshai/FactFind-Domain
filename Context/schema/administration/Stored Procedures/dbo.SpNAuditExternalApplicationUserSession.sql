Create PROCEDURE [dbo].[SpNAuditExternalApplicationUserSession]
	@StampUser varchar (255),
	@ExternalApplicationUserSessionId bigint,
	@StampAction char(1)
AS

INSERT INTO TExternalApplicationUserSessionAudit 
( UserId, TenantId, SessionId, LastAccessed, 
		IP, ExternalApplication, ConcurrencyId, 
	ExternalApplicationUserSessionId, StampAction, StampDateTime, StampUser) 
Select UserId, TenantId, SessionId, LastAccessed, 
		IP, ExternalApplication, ConcurrencyId, 
	ExternalApplicationUserSessionId, @StampAction, GetDate(), @StampUser
FROM TExternalApplicationUserSession
WHERE ExternalApplicationUserSessionId = @ExternalApplicationUserSessionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)