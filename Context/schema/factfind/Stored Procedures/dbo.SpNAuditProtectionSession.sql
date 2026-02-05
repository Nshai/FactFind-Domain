
Create PROCEDURE [dbo].[SpNAuditProtectionSession]
	@StampUser varchar (255),
	@ProtectionSessionId int,
	@StampAction char(1)
AS

INSERT INTO TProtectionSessionAudit 
( TenantId, CreatedDateTime, CreatedByUserId, LastUpdateDateTime, 
		LastUpdateByUserId, CompletedDateTime, ExpiryDateTime, Description, 
		PrimaryPartyId, SecondaryPartyId, DisposabeIncomeAmount, BudgetAmount, 
		StageComplete, DocumentBinderId, 
	ProtectionSessionId, StampAction, StampDateTime, StampUser) 
Select TenantId, CreatedDateTime, CreatedByUserId, LastUpdateDateTime, 
		LastUpdateByUserId, CompletedDateTime, ExpiryDateTime, Description, 
		PrimaryPartyId, SecondaryPartyId, DisposabeIncomeAmount, BudgetAmount, 
		StageComplete, DocumentBinderId, 
	ProtectionSessionId, @StampAction, GetDate(), @StampUser
FROM TProtectionSession
WHERE ProtectionSessionId = @ProtectionSessionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

