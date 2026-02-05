SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveRelationshipsAddresses]
	@CRMContactIds VARCHAR(8000),
	@TenantId bigint,
	@CurrentUserDate datetime
AS

BEGIN


	DECLARE @TrustToSettlerRelType int;
	DECLARE @TrustToTrusteeRelType int;
	DECLARE @TrustToBeneficiaryRelType int;
	
	SELECT  @TrustToSettlerRelType = [RefRelationshipTypeId] 
	FROM [crm].[dbo].[TRefRelationshipType] 
	WHERE RelationshipTypeName = 'Settlor' AND AccountFg = 0 AND TrustFg = 1 AND PersonFg = 1 
	AND ArchiveFg = 0 AND CorporateFg = 1

	SELECT  @TrustToTrusteeRelType = [RefRelationshipTypeId] 
	FROM [crm].[dbo].[TRefRelationshipType] 
	WHERE RelationshipTypeName = 'Trustee' AND AccountFg = 0 AND TrustFg = 1 AND PersonFg = 1 
	AND ArchiveFg = 0 AND CorporateFg = 1

	SELECT  @TrustToBeneficiaryRelType = [RefRelationshipTypeId] 
	FROM [crm].[dbo].[TRefRelationshipType] 
	WHERE RelationshipTypeName = 'Beneficiary (of Trust)' AND AccountFg = 0 AND TrustFg = 1 AND PersonFg = 1 
	AND ArchiveFg = 0 AND CorporateFg = 1


	SELECT
	ad.AddressId,
	ad.CRMContactId								AS [AddressOwnerPartyId],
	CASE WHEN ISNULL(p.PersonId, 0) <> 0
				THEN CONCAT_WS(' ', c.FirstName, c.LastName) 
				ELSE c.CorporateName
		END										AS [AddresseeName],
	ads.AddressLine1,
	ads.AddressLine2,
	ads.AddressLine3,
	ads.AddressLine4,
	ads.CityTown,
	county.CountyCode							AS [CountyCode],
	country.CountryCode							AS [CountryCode],
	ads.Postcode,
	ad.AddressTypeName							AS [AddressType],
	ad.ResidencyStatus,
	ad.ResidentFromDate							AS [ResidentFromDate],
	st.AddressStatus							AS [AddressStatus],
	ad.DefaultFg								AS [IsDefault],
	pd.NumberOfOutbuildings						AS [BuildingHouse],
	CASE 
		-- Only calculate for CURRENT Addresses
		WHEN ad.RefAddressStatusId = 1 AND ad.ResidentFromDate  IS NOT NULL AND ad.ResidentFromDate <= @CurrentUserDate
		THEN factfind.dbo.FnDifferenceTotalMonths(ad.ResidentFromDate, @CurrentUserDate) 
	END											AS [TimeAtAddress]
	FROM TRelationship rel
	JOIN TCRMContact c ON rel.CRMContactToId = c.CRMContactId
	JOIN TRefRelationshipType relType ON relType.RefRelationshipTypeId = rel.RefRelTypeId
	JOIN TRefRelationshipType correspondRelType ON correspondRelType.RefRelationshipTypeId = rel.RefRelCorrespondTypeId
	JOIN TAddress ad ON ad.CRMContactId = rel.CRMContactToId
	JOIN TAddressStore ads ON ads.AddressStoreId = ad.AddressStoreId
	LEFT JOIN TRefCounty county ON county.RefCountyId = ads.RefCountyId
	LEFT JOIN TRefCountry country ON country.RefCountryId = ads.RefCountryId
	JOIN TRefAddressStatus st ON st.RefAddressStatusId = ad.RefAddressStatusId
	JOIN policymanagement.dbo.FnSplit(@CRMContactIds, ',') parslist ON parslist.Value = rel.CRMContactFromId
	LEFT JOIN TPerson p ON p.PersonId = c.PersonId
	LEFT JOIN factfind.dbo.TPropertyDetail pd ON pd.RelatedAddressStoreId = ads.AddressStoreId
	WHERE rel.RefRelTypeId IN (@TrustToSettlerRelType, @TrustToTrusteeRelType)
	AND c.IsDeleted = 0
	AND ISNULL(c.ArchiveFg, 0) = 0
	AND 
	ad.IndClientId = @TenantId

UNION
--Beneficiaries
	SELECT
	ad.AddressId,
	ad.CRMContactId								AS [AddressOwnerPartyId],
	CASE WHEN ISNULL(p.PersonId, 0) <> 0
				THEN CONCAT_WS(' ', c.FirstName, c.LastName) 
				ELSE c.CorporateName
		END										AS [AddresseeName],
	ads.AddressLine1,
	ads.AddressLine2,
	ads.AddressLine3,
	ads.AddressLine4,
	ads.CityTown,
	county.CountyCode							AS [CountyCode],
	country.CountryCode							AS [CountryCode],
	ads.Postcode,
	ad.AddressTypeName							AS [AddressType],
	ad.ResidencyStatus,
	ad.ResidentFromDate							AS [ResidentFromDate],
	st.AddressStatus							AS [AddressStatus],
	ad.DefaultFg								AS [IsDefault],
	pd.NumberOfOutbuildings						AS [BuildingHouse],
	CASE 
		-- Only calculate for CURRENT Addresses
		WHEN ad.RefAddressStatusId = 1 AND ad.ResidentFromDate  IS NOT NULL AND ad.ResidentFromDate <= @CurrentUserDate
		THEN factfind.dbo.FnDifferenceTotalMonths(ad.ResidentFromDate, @CurrentUserDate) 
	END											AS [TimeAtAddress]
		FROM (SELECT * FROM TRelationship WHERE RefRelTypeId = @TrustToBeneficiaryRelType) rel
		FULL OUTER JOIN (SELECT * FROM policymanagement.dbo.TPolicyBeneficary WHERE ISNULL(IsArchived,0) = 0) ben ON rel.CRMContactToId = ben.BeneficaryCRMContactId AND rel.CRMContactFromId = ben.CrmContactId 
	JOIN TCRMContact c ON c.CRMContactId = ISNULL(ben.BeneficaryCRMContactId, rel.CRMContactToId )
	JOIN policymanagement.dbo.FnSplit(@CRMContactIds, ',') parslist ON parslist.Value = ISNULL(ben.CrmContactId, rel.CRMContactFromId)
	JOIN TAddress ad ON ad.CRMContactId = c.CRMContactId
	JOIN TAddressStore ads ON ads.AddressStoreId = ad.AddressStoreId
	LEFT JOIN TRefCounty county ON county.RefCountyId = ads.RefCountyId
	LEFT JOIN TRefCountry country ON country.RefCountryId = ads.RefCountryId
	JOIN TRefAddressStatus st ON st.RefAddressStatusId = ad.RefAddressStatusId
	LEFT JOIN TPerson p ON p.PersonId = c.PersonId
	LEFT JOIN factfind.dbo.TPropertyDetail pd ON pd.RelatedAddressStoreId = ads.AddressStoreId
	WHERE 
	c.IsDeleted = 0	AND ISNULL(c.ArchiveFg, 0) = 0
	AND ad.IndClientId = @TenantId

	ORDER BY AddressOwnerPartyId

END
