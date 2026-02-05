SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditKey]
	@StampUser varchar (255),
	@KeyId bigint,
	@StampAction char(1)
AS

INSERT INTO TKeyAudit 
( RightMask, SystemId, UserId, RoleId, 
		ConcurrencyId, 
	KeyId, StampAction, StampDateTime, StampUser) 
Select RightMask, SystemId, UserId, RoleId, 
		ConcurrencyId, 
	KeyId, @StampAction, GetDate(), @StampUser
FROM TKey
WHERE KeyId = @KeyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
