SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditNote]
	@StampUser varchar (255),
	@NoteId bigint,
	@StampAction char(1)
AS

INSERT INTO TNoteAudit 
( EntityType, EntityId, Notes, LatestNote, 
		ConcurrencyId, 
	NoteId, StampAction, StampDateTime, StampUser) 
Select EntityType, EntityId, Notes, LatestNote, 
		ConcurrencyId, 
	NoteId, @StampAction, GetDate(), @StampUser
FROM TNote
WHERE NoteId = @NoteId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
