SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFinancialNotes]
	@StampUser varchar (255),
	@FinancialNotesId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialNotesAudit 
( CRMContactId, FinancialNotes, ConcurrencyId, 
	FinancialNotesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, FinancialNotes, ConcurrencyId, 
	FinancialNotesId, @StampAction, GetDate(), @StampUser
FROM TFinancialNotes
WHERE FinancialNotesId = @FinancialNotesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
