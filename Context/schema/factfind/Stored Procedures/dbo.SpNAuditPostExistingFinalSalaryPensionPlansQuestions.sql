SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPostExistingFinalSalaryPensionPlansQuestions]
	@StampUser varchar (255),
	@PostExistingFinalSalaryPensionPlansQuestionsId bigint,
	@StampAction char(1)
AS

INSERT INTO TPostExistingFinalSalaryPensionPlansQuestionsAudit 
( CRMContactId, NonDisclosure, ConcurrencyId, 
	PostExistingFinalSalaryPensionPlansQuestionsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, NonDisclosure, ConcurrencyId, 
	PostExistingFinalSalaryPensionPlansQuestionsId, @StampAction, GetDate(), @StampUser
FROM TPostExistingFinalSalaryPensionPlansQuestions
WHERE PostExistingFinalSalaryPensionPlansQuestionsId = @PostExistingFinalSalaryPensionPlansQuestionsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
