SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCorporateContact]
	@StampUser varchar (255),
	@CorporateContactId bigint,
	@StampAction char(1)
AS

INSERT INTO TCorporateContactAudit 
( CRMContactId, ContactId, Name, Description, 
		Details, isDefault, ConcurrencyId, 
	CorporateContactId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, ContactId, Name, Description, 
		Details, isDefault, ConcurrencyId, 
	CorporateContactId, @StampAction, GetDate(), @StampUser
FROM TCorporateContact
WHERE CorporateContactId = @CorporateContactId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
