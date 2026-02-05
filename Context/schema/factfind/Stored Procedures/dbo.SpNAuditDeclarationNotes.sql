SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditDeclarationNotes]
	@StampUser varchar (255),
	@DeclarationNotesId bigint,
	@StampAction char(1)
AS

INSERT INTO TDeclarationNotesAudit 
( CRMContactId, DeclarationNotes, ConcurrencyId, 
	DeclarationNotesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, DeclarationNotes, ConcurrencyId, 
	DeclarationNotesId, @StampAction, GetDate(), @StampUser
FROM TDeclarationNotes
WHERE DeclarationNotesId = @DeclarationNotesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
