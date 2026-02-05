SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPostExistingCashDepositPlansQuestions]
	@StampUser varchar (255),
	@PostExistingCashDepositPlansQuestionsId bigint,
	@StampAction char(1)
AS

INSERT INTO TPostExistingCashDepositPlansQuestionsAudit 
( CRMContactId, NonDisclosure, ConcurrencyId, 
	PostExistingCashDepositPlansQuestionsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, NonDisclosure, ConcurrencyId, 
	PostExistingCashDepositPlansQuestionsId, @StampAction, GetDate(), @StampUser
FROM TPostExistingCashDepositPlansQuestions
WHERE PostExistingCashDepositPlansQuestionsId = @PostExistingCashDepositPlansQuestionsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
