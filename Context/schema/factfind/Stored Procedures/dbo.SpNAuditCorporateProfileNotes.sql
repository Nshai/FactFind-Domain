SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCorporateProfileNotes]
	@StampUser varchar (255),
	@CorporateProfileNotesId bigint,
	@StampAction char(1)
AS

INSERT INTO TCorporateProfileNotesAudit 
( CRMContactId, Notes, ConcurrencyId, 
	CorporateProfileNotesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Notes, ConcurrencyId, 
	CorporateProfileNotesId, @StampAction, GetDate(), @StampUser
FROM TCorporateProfileNotes
WHERE CorporateProfileNotesId = @CorporateProfileNotesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
