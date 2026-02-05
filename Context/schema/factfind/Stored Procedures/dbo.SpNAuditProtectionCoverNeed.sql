
Create PROCEDURE [dbo].[SpNAuditProtectionCoverNeed]
	@StampUser varchar (255),
	@ProtectionCoverNeedId int,
	@StampAction char(1)
AS

INSERT INTO TProtectionCoverNeedAudit 
( TenantId, PartyId, JointPartyId, Frequency, 
		Term, TermType, Notes, NeedType, CoverAmount, AssociatedCoverSummary, SystemGenerated,
	ProtectionCoverNeedId, StampAction, StampDateTime, StampUser) 
Select TenantId, PartyId, JointPartyId, Frequency, 
		Term, TermType, Notes, NeedType, CoverAmount, AssociatedCoverSummary, SystemGenerated,
	ProtectionCoverNeedId, @StampAction, GetDate(), @StampUser
FROM TProtectionCoverNeed
WHERE ProtectionCoverNeedId = @ProtectionCoverNeedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

