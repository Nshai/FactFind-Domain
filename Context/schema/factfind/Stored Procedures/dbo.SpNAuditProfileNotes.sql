SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditProfileNotes]
	@StampUser varchar (255),
	@ProfileNotesId bigint,
	@StampAction char(1)
AS

INSERT INTO TProfileNotesAudit 
( CRMContactId, Notes, ConcurrencyId, 
	ProfileNotesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Notes, ConcurrencyId, 
	ProfileNotesId, @StampAction, GetDate(), @StampUser
FROM TProfileNotes
WHERE ProfileNotesId = @ProfileNotesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
