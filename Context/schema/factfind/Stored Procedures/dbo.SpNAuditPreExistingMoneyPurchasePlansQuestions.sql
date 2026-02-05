SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPreExistingMoneyPurchasePlansQuestions]
	@StampUser varchar (255),
	@PreExistingMoneyPurchasePlansQuestionsId bigint,
	@StampAction char(1)
AS
INSERT INTO TPreExistingMoneyPurchasePlansQuestionsAudit (
	CRMContactId, ExistingMoneyPurchaseSchemes, ConcurrencyId, 
	PreExistingMoneyPurchasePlansQuestionsId, HasPersonalPensions, 
	IsPersonalPensionNonDisclosed, HasAnnuities, IsAnnuityNonDisclosed,
	StampAction, StampDateTime, StampUser) 
SELECT
	CRMContactId, ExistingMoneyPurchaseSchemes, ConcurrencyId, 
	PreExistingMoneyPurchasePlansQuestionsId, HasPersonalPensions, 
	IsPersonalPensionNonDisclosed, HasAnnuities, IsAnnuityNonDisclosed,
	@StampAction, GetDate(), @StampUser
FROM 
	TPreExistingMoneyPurchasePlansQuestions
WHERE 
	PreExistingMoneyPurchasePlansQuestionsId = @PreExistingMoneyPurchasePlansQuestionsId

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)
GO
