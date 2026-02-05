SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditMortgageRiskNotes]
	@StampUser varchar (255),
	@MortgageRiskNotesId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageRiskNotesAudit 
( CRMContactId, riskComment, ConcurrencyId, 
	MortgageRiskNotesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, riskComment, ConcurrencyId, 
	MortgageRiskNotesId, @StampAction, GetDate(), @StampUser
FROM TMortgageRiskNotes
WHERE MortgageRiskNotesId = @MortgageRiskNotesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
