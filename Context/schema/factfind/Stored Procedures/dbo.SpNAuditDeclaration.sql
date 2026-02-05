SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditDeclaration]
	@StampUser varchar (255),
	@DeclarationId bigint,
	@StampAction char(1)
AS

INSERT INTO TDeclarationAudit 
(CRMContactId, TOBDate, TOBVersion, CostKeyfacts, ServicesKeyFacts, CompletedDate, 
	IDCheckedDate, DeclarationDate, TaskId, ConcurrencyId, DateTermsOfBusinessIssued, DateTermsOfRefundsIssued, 
	DisclosureDocumentType,
	DeclarationId, StampAction, StampDateTime, StampUser)
SELECT  CRMContactId, TOBDate, TOBVersion, CostKeyfacts, ServicesKeyFacts, CompletedDate, 
	IDCheckedDate, DeclarationDate, TaskId, ConcurrencyId, DateTermsOfBusinessIssued, DateTermsOfRefundsIssued, 
	DisclosureDocumentType,
	DeclarationId, @StampAction, GetDate(), @StampUser
FROM TDeclaration
WHERE DeclarationId = @DeclarationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
