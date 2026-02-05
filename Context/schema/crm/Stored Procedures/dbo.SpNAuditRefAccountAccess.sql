SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefAccountAccess]
	@StampUser varchar (255),
	@RefAccountAccessId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefAccountAccessAudit 
(AccessTypeName, ConcurrencyId,
	RefAccountAccessId, StampAction, StampDateTime, StampUser)
SELECT  AccessTypeName, ConcurrencyId,
	RefAccountAccessId, @StampAction, GetDate(), @StampUser
FROM TRefAccountAccess
WHERE RefAccountAccessId = @RefAccountAccessId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
