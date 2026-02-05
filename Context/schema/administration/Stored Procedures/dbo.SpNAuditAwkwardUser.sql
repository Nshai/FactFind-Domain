SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAwkwardUser]
	@StampUser varchar (255),
	@AwkwardUserId bigint,
	@StampAction char(1)
AS

INSERT INTO TAwkwardUserAudit 
( UserId, IsExempt, DateAdded, ConcurrencyId, 
		
	AwkwardUserId, StampAction, StampDateTime, StampUser) 
Select UserId, IsExempt, DateAdded, ConcurrencyId, 
		
	AwkwardUserId, @StampAction, GetDate(), @StampUser
FROM TAwkwardUser
WHERE AwkwardUserId = @AwkwardUserId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
