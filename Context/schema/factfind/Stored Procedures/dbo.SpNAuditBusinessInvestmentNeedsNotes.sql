SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditBusinessInvestmentNeedsNotes]
	@StampUser varchar (255),
	@BusinessInvestmentNeedsNotesId bigint,
	@StampAction char(1)
AS

INSERT INTO TBusinessInvestmentNeedsNotesAudit 
( CRMContactId, Notes, ConcurrencyId, 
	BusinessInvestmentNeedsNotesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Notes, ConcurrencyId, 
	BusinessInvestmentNeedsNotesId, @StampAction, GetDate(), @StampUser
FROM TBusinessInvestmentNeedsNotes
WHERE BusinessInvestmentNeedsNotesId = @BusinessInvestmentNeedsNotesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
