SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPreExistingFinalSalaryPensionPlansQuestions]
	@StampUser varchar (255),
	@PreExistingFinalSalaryPensionPlansQuestionsId bigint,
	@StampAction char(1)
AS

INSERT INTO TPreExistingFinalSalaryPensionPlansQuestionsAudit 
( CRMContactId, EmployerHasPensionSchemeFg, MemberOfEmployerPensionSchemeFg, EligibleToJoinEmployerPensionSchemeFg, 
		DateEligibleToJoinEmployerPensionScheme, WhyNotJoinedFg, HasExistingSchemesFg, ConcurrencyId, 
		
	PreExistingFinalSalaryPensionPlansQuestionsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, EmployerHasPensionSchemeFg, MemberOfEmployerPensionSchemeFg, EligibleToJoinEmployerPensionSchemeFg, 
		DateEligibleToJoinEmployerPensionScheme, WhyNotJoinedFg, HasExistingSchemesFg, ConcurrencyId, 
		
	PreExistingFinalSalaryPensionPlansQuestionsId, @StampAction, GetDate(), @StampUser
FROM TPreExistingFinalSalaryPensionPlansQuestions
WHERE PreExistingFinalSalaryPensionPlansQuestionsId = @PreExistingFinalSalaryPensionPlansQuestionsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
