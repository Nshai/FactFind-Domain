SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditProductApplication]
	@StampUser varchar (255),
	@ProductApplicationId bigint,
	@StampAction char(1)
AS

INSERT INTO TProductApplicationAudit
( 
	AppReceiptNo, Errors, IndigoClientId,RiskAddressId,CorrespondanceAddressId,BankAccountId,DirectDebitDate,Applicant1Id,	Applicant2Id,
	AdditionalInfo,YourRef,MortgageLender,MortgageStartDate,PolicyStartDate,TypeOfBorrowing,SharedOwnership,AdvancedBorrowing,RefProductTypeId,
	ProfessionalContactId,IsFaxAcceptToSolicitor,IsFaxRiskNotificationToSolicitor,MortgageCompletionDate,QuoteResultId,
	ConcurrencyId, ProductApplicationId, StampAction, StampDateTime, StampUser
) 
SELECT  
	AppReceiptNo, Errors, IndigoClientId,RiskAddressId,CorrespondanceAddressId,BankAccountId,DirectDebitDate,Applicant1Id,	Applicant2Id,
	AdditionalInfo,YourRef,MortgageLender,MortgageStartDate,PolicyStartDate,TypeOfBorrowing,SharedOwnership,AdvancedBorrowing,RefProductTypeId,
	ProfessionalContactId,IsFaxAcceptToSolicitor,IsFaxRiskNotificationToSolicitor,MortgageCompletionDate,QuoteResultId,
	ConcurrencyId, ProductApplicationId, @StampAction, GetDate(), @StampUser

FROM TProductApplication
WHERE ProductApplicationId = @ProductApplicationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
