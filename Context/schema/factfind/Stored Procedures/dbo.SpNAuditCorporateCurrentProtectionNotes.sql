SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCorporateCurrentProtectionNotes]
	@StampUser varchar (255),
	@CorporateCurrentProtectionNotesId bigint,
	@StampAction char(1)
AS

INSERT INTO TCorporateCurrentProtectionNotesAudit 
( CRMContactId, Notes, ConcurrencyId, 
	CorporateCurrentProtectionNotesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Notes, ConcurrencyId, 
	CorporateCurrentProtectionNotesId, @StampAction, GetDate(), @StampUser
FROM TCorporateCurrentProtectionNotes
WHERE CorporateCurrentProtectionNotesId = @CorporateCurrentProtectionNotesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
