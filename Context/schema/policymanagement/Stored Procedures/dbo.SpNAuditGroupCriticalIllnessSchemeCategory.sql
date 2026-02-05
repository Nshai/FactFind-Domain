SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditGroupCriticalIllnessSchemeCategory]
	@StampUser varchar (255),
	@GroupCriticalIllnessSchemeCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TGroupCriticalIllnessSchemeCategoryAudit 
( GroupSchemeCategoryId, RefBenefitBasisId, RefCoverToId, UnitRate, 
		RefIllnessConditionTypeId, CriticalIllnessCoverAmount, RefTotalPermanentDisabilityTypeId, SurvivalPeriod, 
		ChildrensCoverAmount, ConcurrencyId, TenantId, 
	GroupCriticalIllnessSchemeCategoryId, StampAction, StampDateTime, StampUser) 
Select GroupSchemeCategoryId, RefBenefitBasisId, RefCoverToId, UnitRate, 
		RefIllnessConditionTypeId, CriticalIllnessCoverAmount, RefTotalPermanentDisabilityTypeId, SurvivalPeriod, 
		ChildrensCoverAmount, ConcurrencyId, TenantId, 
	GroupCriticalIllnessSchemeCategoryId, @StampAction, GetDate(), @StampUser
FROM TGroupCriticalIllnessSchemeCategory
WHERE GroupCriticalIllnessSchemeCategoryId = @GroupCriticalIllnessSchemeCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
