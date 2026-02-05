SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditGroupPHISchemeCategory] 
 @StampUser varchar (255),  
 @GroupPHISchemeCategoryId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TGroupPHISchemeCategoryAudit   
(GroupPHISchemeCategoryId,
 GroupSchemeCategoryId,
	RefBenefitBasisId,
	RefBenefitFrequencyId,
	SplitCoverAmount, 
	RefSplitBenefitFrequencyId, 
	SplitDeferredPeriod, 
	RefSplitDeferredPeriodIntervalId, 
	RefDeductionId, 
	RefCoverToId, 
	UnitRate, 
	RefClaimEscalationTypeId,
	RefTotalPermanentDisabilityTypeId, 
	RefContributionsCoveredId, 
	EmployerNICovered, 
	HolidayPayCovered, 
	DiscountforConcurrentPMI, 
	EAPIncluded, 
	ExtendedCoverAvailable, 
	CoverlinkedGroupPension,
	TenantId,
	ConcurrencyId, 
	StampAction,
	StampDateTime, 
	StampUser)
Select GroupPHISchemeCategoryId,
	GroupSchemeCategoryId,
	RefBenefitBasisId,
	RefBenefitFrequencyId,
	SplitCoverAmount, 
	RefSplitBenefitFrequencyId, 
	SplitDeferredPeriod, 
	RefSplitDeferredPeriodIntervalId, 
	RefDeductionId, 
	RefCoverToId, 
	UnitRate, 
	RefClaimEscalationTypeId,
	RefTotalPermanentDisabilityTypeId, 
	RefContributionsCoveredId, 
	EmployerNICovered, 
	HolidayPayCovered, 
	DiscountforConcurrentPMI, 
	EAPIncluded, 
	ExtendedCoverAvailable, 
	CoverlinkedGroupPension,
	TenantId,
	ConcurrencyId, @StampAction, GetDate(), @StampUser  
FROM TGroupPHISchemeCategory  
WHERE GroupPHISchemeCategoryId = @GroupPHISchemeCategoryId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
