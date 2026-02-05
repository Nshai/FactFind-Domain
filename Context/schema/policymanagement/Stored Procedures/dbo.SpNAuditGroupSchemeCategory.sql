SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditGroupSchemeCategory]
	@StampUser varchar (255),
	@GroupSchemeCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TGroupSchemeCategoryAudit 
( GroupSchemeId, TenantId, CategoryName, 
		MinServiceRequirementAmount, MinServiceRequirementType, EligibilityAgeFrom, EligibilityAgeTo, 
		StandardRetirementAgeMale, StandardRetirementAgeFemale, EmployeeContribution, EmployerContribution, 
		BasisOfSalary, BasisOfSalaryOther, BasisOfSalaryAsAt, FreeCoverAmount, 
		FreeCoverAmountType, CoverAmount, CoverAmountType, CoverAmountNotes, 
		CoverToAge, MethodOfCosting, RateGuaranteeExpires, DeferredPeriod, 
		DeferredPeriodType, ClaimEscalationRate, IncreasesAt, LimitedClaimPeriod, 
		LimitedClaimPeriodType, DisabilityDefinition, IsPensionContributionCovered, PensionContributionCoveredEmployeeAmount, 
		PensionContributionCoveredEmployerAmount, PSTRNumber, TemporaryAbsence, IsSpousesBenefitsIncluded, 
		SpousesCoverAmount, SpousesCoverToAge, SpousesMethodOfCosting, IsArchived, 
		IsDefault, IsCalculateContribution, ConcurrencyId, 
	GroupSchemeCategoryId, StampAction, StampDateTime, StampUser,FeeModelId) 
Select GroupSchemeId, TenantId, CategoryName, 
		MinServiceRequirementAmount, MinServiceRequirementType, EligibilityAgeFrom, EligibilityAgeTo, 
		StandardRetirementAgeMale, StandardRetirementAgeFemale, EmployeeContribution, EmployerContribution, 
		BasisOfSalary, BasisOfSalaryOther, BasisOfSalaryAsAt, FreeCoverAmount, 
		FreeCoverAmountType, CoverAmount, CoverAmountType, CoverAmountNotes, 
		CoverToAge, MethodOfCosting, RateGuaranteeExpires, DeferredPeriod, 
		DeferredPeriodType, ClaimEscalationRate, IncreasesAt, LimitedClaimPeriod, 
		LimitedClaimPeriodType, DisabilityDefinition, IsPensionContributionCovered, PensionContributionCoveredEmployeeAmount, 
		PensionContributionCoveredEmployerAmount, PSTRNumber, TemporaryAbsence, IsSpousesBenefitsIncluded, 
		SpousesCoverAmount, SpousesCoverToAge, SpousesMethodOfCosting, IsArchived, 
		IsDefault, IsCalculateContribution, ConcurrencyId, 
	GroupSchemeCategoryId, @StampAction, GetDate(), @StampUser, FeeModelId
FROM TGroupSchemeCategory
WHERE GroupSchemeCategoryId = @GroupSchemeCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
