Create PROCEDURE [dbo].[SpNAuditExistingCover]
	@StampUser varchar (255),
	@ExistingCoverId int,
	@StampAction char(1)
AS

INSERT INTO TExistingCoverAudit 
( TenantId, ProtectionCoverNeedId, LifeCoverAmount, CriticalIllnessCoverAmount, 
		AssociatedLifeCoverAmount, AssociatedIllnessCoverAmount, PolicyBusinessId, PartyId, 
		PlanOwnerNames, CoverDescription, PlanEndDate, CoverFrequency,
	ExistingCoverId, StampAction, StampDateTime, StampUser) 
Select TenantId, ProtectionCoverNeedId, LifeCoverAmount, CriticalIllnessCoverAmount, 
		AssociatedLifeCoverAmount, AssociatedIllnessCoverAmount, PolicyBusinessId, PartyId, 
		PlanOwnerNames, CoverDescription, PlanEndDate, CoverFrequency,
	ExistingCoverId, @StampAction, GetDate(), @StampUser
FROM TExistingCover
WHERE ExistingCoverId = @ExistingCoverId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

