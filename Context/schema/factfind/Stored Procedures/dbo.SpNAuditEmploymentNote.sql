SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditEmploymentNote]
	@StampUser varchar (255),
	@EmploymentNoteId bigint,
	@StampAction char(1)
AS

INSERT INTO TEmploymentNoteAudit 
(ConcurrencyId, CRMContactId, Note,
	EmploymentNoteId, StampAction, StampDateTime, StampUser)
SELECT  ConcurrencyId, CRMContactId, Note,
	EmploymentNoteId, @StampAction, GetDate(), @StampUser
FROM TEmploymentNote
WHERE EmploymentNoteId = @EmploymentNoteId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
