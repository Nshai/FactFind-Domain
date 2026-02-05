SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPensionContributionsDetails]
	@StampUser varchar (255),
	@PensionContributionsDetailsId bigint,
	@StampAction char(1)
AS
INSERT INTO TPensionContributionsDetailsAudit (
	CRMContactId, AnnualContributionCompany, NormalRetirementAge, NumberOfEmployeesInScheme, 
	LumpSumOnDeathInService, WidowPensionOnDeathInService, WidowPensionOnDeathAfterRetirement, HowIsTheSchemeCalculated2, 
	DetailsOfInHouseAVCScheme, BenefitsPayableEmployeeDisabled, AdditionalBenefitsForDirectors, AdditionalBenefitsForDirectorsDetails, 
	DirectorsRetiringShortly, DirectorsRetiringShortlyDetails, NewDirectors, NewDirectorsDetails, 
	InterestedInGPP, InterestedInDirectOffer, Notes, ConcurrencyId, 	
	PensionContributionsDetailsId, AccrualRate,
	StampAction, StampDateTime, StampUser) 
SELECT
	CRMContactId, AnnualContributionCompany, NormalRetirementAge, NumberOfEmployeesInScheme, 
	LumpSumOnDeathInService, WidowPensionOnDeathInService, WidowPensionOnDeathAfterRetirement, HowIsTheSchemeCalculated2, 
	DetailsOfInHouseAVCScheme, BenefitsPayableEmployeeDisabled, AdditionalBenefitsForDirectors, AdditionalBenefitsForDirectorsDetails, 
	DirectorsRetiringShortly, DirectorsRetiringShortlyDetails, NewDirectors, NewDirectorsDetails, 
	InterestedInGPP, InterestedInDirectOffer, Notes, ConcurrencyId, 
	PensionContributionsDetailsId, AccrualRate,
	@StampAction, GetDate(), @StampUser
FROM 
	TPensionContributionsDetails
WHERE 
	PensionContributionsDetailsId = @PensionContributionsDetailsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
