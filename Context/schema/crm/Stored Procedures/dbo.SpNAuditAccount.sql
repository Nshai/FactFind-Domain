SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAccount]
	@StampUser varchar (255),
	@AccountId bigint,
	@StampAction char(1)
AS

INSERT INTO TAccountAudit 
( CRMContactId, AccountTypeId, RefAccountAccessId, RefProductProviderId, 
		IndigoClientId, CreatedBy, ConcurrencyId, 
	AccountId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, AccountTypeId, RefAccountAccessId, RefProductProviderId, 
		IndigoClientId, CreatedBy, ConcurrencyId, 
	AccountId, @StampAction, GetDate(), @StampUser
FROM TAccount
WHERE AccountId = @AccountId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
