SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPostExistingMoneyPurchasePlansQuestions]
	@StampUser varchar (255),
	@PostExistingMoneyPurchasePlansQuestionsId bigint,
	@StampAction char(1)
AS

INSERT INTO TPostExistingMoneyPurchasePlansQuestionsAudit 
( CRMContactId, SSPContractedOut, NonDisclosure, ConcurrencyId, 
		
	PostExistingMoneyPurchasePlansQuestionsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, SSPContractedOut, NonDisclosure, ConcurrencyId, 
		
	PostExistingMoneyPurchasePlansQuestionsId, @StampAction, GetDate(), @StampUser
FROM TPostExistingMoneyPurchasePlansQuestions
WHERE PostExistingMoneyPurchasePlansQuestionsId = @PostExistingMoneyPurchasePlansQuestionsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
