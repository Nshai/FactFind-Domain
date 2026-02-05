SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditHomeInsuranceQuote]
	@StampUser varchar (255),
	@QuoteId bigint,
	@StampAction char(1)
AS

INSERT INTO THomeInsuranceQuoteAudit 
	(
	RefPropertyTypeId,
	PropertyDetailId,
	Postcode,
	NumberOfBedrooms,
	IncludeAccidentalBuildingDamageCover,
	IncludeAccidentalContentsDamageCover,
	NoClaimYearsBuilding,
	NoClaimYearsContents,
	RefCoverTypeId,
	BuildYear,
	UnspecifiedItemAmount,
	IncludeBuildingsExtraCover,
	IncludeContentsExtraCover,
	IncludeHomeEmergencyCover,
	IncludeLegalAssistanceCover,
	PolicyExcess,
	IsMasonryBuild,
	IsPermanentlyOccupied,
	HasSubsidence,
	ApplicantOrFamilyHasConviction,
	UnoccupiedSixtyPlusDays,
	UsedForBusinessPurposes,
	ApplicantHasPreviousClaims,
	IsFurnished,
	NoOfPSLandlordPolicy,
	IsPrivateIndividual,
	HasInsuranceDeclined,
	UsedForAsylumSeekers,
	IsDirectTenancyAgreement,
	HasLessThanSixIndividuals,
	IsSelfContainedUnits,
	HasPropertyFlooded,
	IncludeStudentTenants,
	IncludeDsstenants,
	ConcurrencyId,
	QuoteId,
	StampAction,
	StampDateTime,
	StampUser
	) 
SELECT 
	RefPropertyTypeId,
	PropertyDetailId,
	Postcode,
	NumberOfBedrooms,
	IncludeAccidentalBuildingDamageCover,
	IncludeAccidentalContentsDamageCover,
	NoClaimYearsBuilding,
	NoClaimYearsContents,
	RefCoverTypeId,
	BuildYear,
	UnspecifiedItemAmount,
	IncludeBuildingsExtraCover,
	IncludeContentsExtraCover,
	IncludeHomeEmergencyCover,
	IncludeLegalAssistanceCover,
	PolicyExcess,
	IsMasonryBuild,
	IsPermanentlyOccupied,
	HasSubsidence,
	ApplicantOrFamilyHasConviction,
	UnoccupiedSixtyPlusDays,
	UsedForBusinessPurposes,
	ApplicantHasPreviousClaims,
	IsFurnished,
	NoOfPSLandlordPolicy,
	IsPrivateIndividual,
	HasInsuranceDeclined,
	UsedForAsylumSeekers,
	IsDirectTenancyAgreement,
	HasLessThanSixIndividuals,
	IsSelfContainedUnits,
	HasPropertyFlooded,
	IncludeStudentTenants,
	IncludeDsstenants,
	ConcurrencyId,
	QuoteId,
	@StampAction, 
	GetDate(), 
	@StampUser
FROM THomeInsuranceQuote
WHERE QuoteId = @QuoteId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
