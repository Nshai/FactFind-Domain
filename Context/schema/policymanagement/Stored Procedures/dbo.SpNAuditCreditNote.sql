SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCreditNote]
	@StampUser varchar (255),
	@CreditNoteId bigint,
	@StampAction char(1)
AS

INSERT INTO TCreditNoteAudit 
( FeeId, RetainerId, ProvBreakId, NetAmount, 
		VATAmount, DateRaised, SentToClientDate, Description, 
		IndigoClientId, SequentialRef, ConcurrencyId, 
	CreditNoteId, StampAction, StampDateTime, StampUser) 
Select FeeId, RetainerId, ProvBreakId, NetAmount, 
		VATAmount, DateRaised, SentToClientDate, Description, 
		IndigoClientId, SequentialRef, ConcurrencyId, 
	CreditNoteId, @StampAction, GetDate(), @StampUser
FROM TCreditNote
WHERE CreditNoteId = @CreditNoteId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
