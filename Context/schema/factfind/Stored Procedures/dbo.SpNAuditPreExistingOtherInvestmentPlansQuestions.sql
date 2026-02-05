SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPreExistingOtherInvestmentPlansQuestions]
	@StampUser varchar (255),
	@PreExistingOtherInvestmentPlansQuestionsId bigint,
	@StampAction char(1)
AS

INSERT INTO TPreExistingOtherInvestmentPlansQuestionsAudit 
( CRMContactId, ExistingOtherInvestments, ConcurrencyId, 
	PreExistingOtherInvestmentPlansQuestionsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, ExistingOtherInvestments, ConcurrencyId, 
	PreExistingOtherInvestmentPlansQuestionsId, @StampAction, GetDate(), @StampUser
FROM TPreExistingOtherInvestmentPlansQuestions
WHERE PreExistingOtherInvestmentPlansQuestionsId = @PreExistingOtherInvestmentPlansQuestionsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
