SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditChecklist]
	@StampUser varchar (255),
	@ChecklistId bigint,
	@StampAction char(1)
AS

INSERT INTO TChecklistAudit 
( CRMContactId, producttypes, repaymentmethods, interestonly, 
		interestonlyrepaymentmethods, nonrepaymentconsequences, customerresponsibility, earlyrepaymentconsequences, 
		relatedinsurances, insuranceresponsibility, explaininsuranceconditions, costsandfees, 
		portableterms, detailspassedtocra, higherlendingcharge, circumstancechangeconsequences, 
		jointapplications, addingfeestoloan, ConcurrencyId, 
	ChecklistId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, producttypes, repaymentmethods, interestonly, 
		interestonlyrepaymentmethods, nonrepaymentconsequences, customerresponsibility, earlyrepaymentconsequences, 
		relatedinsurances, insuranceresponsibility, explaininsuranceconditions, costsandfees, 
		portableterms, detailspassedtocra, higherlendingcharge, circumstancechangeconsequences, 
		jointapplications, addingfeestoloan, ConcurrencyId, 
	ChecklistId, @StampAction, GetDate(), @StampUser
FROM TChecklist
WHERE ChecklistId = @ChecklistId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
