SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPostExistingOtherInvestmentPlansQuestions]
	@StampUser varchar (255),
	@PostExistingOtherInvestmentPlansQuestionsId bigint,
	@StampAction char(1)
AS

INSERT INTO TPostExistingOtherInvestmentPlansQuestionsAudit 
( CRMContactId, NonDisclosure, ConcurrencyId, 
	PostExistingOtherInvestmentPlansQuestionsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, NonDisclosure, ConcurrencyId, 
	PostExistingOtherInvestmentPlansQuestionsId, @StampAction, GetDate(), @StampUser
FROM TPostExistingOtherInvestmentPlansQuestions
WHERE PostExistingOtherInvestmentPlansQuestionsId = @PostExistingOtherInvestmentPlansQuestionsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
