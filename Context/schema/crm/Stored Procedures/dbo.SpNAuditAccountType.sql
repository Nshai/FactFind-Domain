SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAccountType]
	@StampUser varchar (255),
	@AccountTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TAccountTypeAudit 
( AccountTypeName, IsForCorporate, IsForIndividual, IsNotModifiable, 
		IsArchived, IndigoClientId, ConcurrencyId, 
	AccountTypeId, StampAction, StampDateTime, StampUser) 
Select AccountTypeName, IsForCorporate, IsForIndividual, IsNotModifiable, 
		IsArchived, IndigoClientId, ConcurrencyId, 
	AccountTypeId, @StampAction, GetDate(), @StampUser
FROM TAccountType
WHERE AccountTypeId = @AccountTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
