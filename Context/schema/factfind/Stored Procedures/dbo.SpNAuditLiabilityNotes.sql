SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLiabilityNotes]
	@StampUser varchar (255),
	@LiabilityNotesId bigint,
	@StampAction char(1)
AS

INSERT INTO TLiabilityNotesAudit 
( CRMContactId, LiabilityNotes, ConcurrencyId, 
	LiabilityNotesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, LiabilityNotes, ConcurrencyId, 
	LiabilityNotesId, @StampAction, GetDate(), @StampUser
FROM TLiabilityNotes
WHERE LiabilityNotesId = @LiabilityNotesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
