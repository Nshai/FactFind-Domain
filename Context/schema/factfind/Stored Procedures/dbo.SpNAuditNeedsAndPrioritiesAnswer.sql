SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditNeedsAndPrioritiesAnswer]
	@StampUser varchar (255),
	@NeedsAndPrioritiesAnswerId bigint,
	@StampAction char(1)
AS

INSERT INTO TNeedsAndPrioritiesAnswerAudit (
	NeedsAndPrioritiesAnswerId, ConcurrencyId, 
	CRMContactId, QuestionId, AnswerId, FreeTextAnswer, [AnswerValue], Notes, AnswerOptions,
	StampAction, StampDateTime, StampUser) 
SELECT 
	NeedsAndPrioritiesAnswerId, ConcurrencyId, 
	CRMContactId, QuestionId, AnswerId, FreeTextAnswer, [AnswerValue], Notes, AnswerOptions,
	@StampAction, GETDATE(), @StampUser
FROM 
	TNeedsAndPrioritiesAnswer
WHERE 
	NeedsAndPrioritiesAnswerId = @NeedsAndPrioritiesAnswerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
