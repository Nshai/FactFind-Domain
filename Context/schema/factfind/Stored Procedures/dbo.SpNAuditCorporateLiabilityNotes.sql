SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCorporateLiabilityNotes]
	@StampUser varchar (255),
	@CorporateLiabilityNotesId bigint,
	@StampAction char(1)
AS

INSERT INTO TCorporateLiabilityNotesAudit 
( CRMContactId, Notes, ConcurrencyId, 
	CorporateLiabilityNotesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Notes, ConcurrencyId, 
	CorporateLiabilityNotesId, @StampAction, GetDate(), @StampUser
FROM TCorporateLiabilityNotes
WHERE CorporateLiabilityNotesId = @CorporateLiabilityNotesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
