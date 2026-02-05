SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditUserExtended]
	@StampUser varchar (255),
	@UserExtendedId int,
	@StampAction char(1)
AS

INSERT INTO TUserExtendedAudit 
(UserId, MigrationRef, ConcurrencyId, UserExtendedId, StampAction, StampDateTime, StampUser) 
SELECT UserId, MigrationRef, ConcurrencyId, UserExtendedId, @StampAction, GetDate(), @StampUser
FROM TUserExtended
WHERE UserExtendedId = @UserExtendedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO