SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPreExistingCashDepositPlansQuestions]
	@StampUser varchar (255),
	@PreExistingCashDepositPlansQuestionsId bigint,
	@StampAction char(1)
AS

INSERT INTO TPreExistingCashDepositPlansQuestionsAudit 
( CRMContactId, ExistingCashDepositAccounts, ConcurrencyId, 
	PreExistingCashDepositPlansQuestionsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, ExistingCashDepositAccounts, ConcurrencyId, 
	PreExistingCashDepositPlansQuestionsId, @StampAction, GetDate(), @StampUser
FROM TPreExistingCashDepositPlansQuestions
WHERE PreExistingCashDepositPlansQuestionsId = @PreExistingCashDepositPlansQuestionsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
