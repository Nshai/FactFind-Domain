SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditGeneralBusinessDetailsNotes]
	@StampUser varchar (255),
	@GeneralBusinessDetailsNotesId bigint,
	@StampAction char(1)
AS

INSERT INTO TGeneralBusinessDetailsNotesAudit 
( CRMContactId, Notes, ConcurrencyId, 
	GeneralBusinessDetailsNotesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Notes, ConcurrencyId, 
	GeneralBusinessDetailsNotesId, @StampAction, GetDate(), @StampUser
FROM TGeneralBusinessDetailsNotes
WHERE GeneralBusinessDetailsNotesId = @GeneralBusinessDetailsNotesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
