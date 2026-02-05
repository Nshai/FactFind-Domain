Create PROCEDURE [dbo].[SpNAuditProtectionCoverNeedPlan]
	@StampUser varchar (255),
	@ProtectionCoverNeedPlanId int,
	@StampAction char(1)
AS

INSERT INTO TProtectionCoverNeedPlanAudit 
( TenantId, PlanId, PartyId,  
		LifeCoverAmount, CriticalIllnessCoverAmount, PlanOwnerNames, CoverDescription, 
		PlanEndDate, NeedAnalysisType, CoverFrequency,
	ProtectionCoverNeedPlanId, StampAction, StampDateTime, StampUser) 
Select TenantId, PlanId, PartyId, 
		LifeCoverAmount, CriticalIllnessCoverAmount, PlanOwnerNames, CoverDescription, 
		PlanEndDate, NeedAnalysisType, CoverFrequency,
	ProtectionCoverNeedPlanId, @StampAction, GetDate(), @StampUser
FROM TProtectionCoverNeedPlan
WHERE ProtectionCoverNeedPlanId = @ProtectionCoverNeedPlanId


IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

