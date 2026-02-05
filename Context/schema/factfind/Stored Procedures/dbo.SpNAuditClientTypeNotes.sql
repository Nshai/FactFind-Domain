SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditClientTypeNotes]
	@StampUser varchar (255),
	@ClientTypeNotesId bigint,
	@StampAction char(1)
AS

INSERT INTO TClientTypeNotesAudit 
( CRMContactId, ClientTypeNotes, ConcurrencyId, 
	ClientTypeNotesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, ClientTypeNotes, ConcurrencyId, 
	ClientTypeNotesId, @StampAction, GetDate(), @StampUser
FROM TClientTypeNotes
WHERE ClientTypeNotesId = @ClientTypeNotesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
