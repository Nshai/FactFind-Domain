SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditMortgageChecklistQuestionAnswer]
	@StampUser varchar (255),
	@MortgageChecklistQuestionAnswerId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageChecklistQuestionAnswerAudit 
( MortgageChecklistQuestionAnswerId,MortgageChecklistQuestionId,
	Answer,CRMContactId,TenantId,ConcurrencyId,
	StampAction, StampDateTime, StampUser) 
Select MortgageChecklistQuestionAnswerId,MortgageChecklistQuestionId,
	Answer,CRMContactId,TenantId,ConcurrencyId, 
	@StampAction, GetDate(), @StampUser
FROM TMortgageChecklistQuestionAnswer
WHERE MortgageChecklistQuestionAnswerId = @MortgageChecklistQuestionAnswerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
