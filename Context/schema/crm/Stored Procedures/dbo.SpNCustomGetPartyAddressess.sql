SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetPartyAddressess]	
	@CRMContactIds VARCHAR(8000),
	@TenantId bigint,
	@CurrentUserDate datetime
AS


SELECT  
	a.AddressId,
	a.CRMContactId AS AddressOwnerPartyId,
	CASE WHEN ISNULL(p.PersonId, 0) <> 0
				THEN (p.Title + ' ' + c.FirstName + ' ' + c.LastName)
				ELSE c.CorporateName
		END AS AddresseeName,
	s.AddressLine1,
	s.AddressLine2,
	s.AddressLine3,
	s.AddressLine4,
	s.CityTown,
	county.CountyCode,
	country.CountryCode,
	s.Postcode,
	a.DefaultFg AS IsDefault,
	ISNULL(a.AddressTypeName,'') AS AddressType,
	a.ResidencyStatus,
	a.ResidentFromDate,
	a.ResidentToDate,
	CASE 
		-- Only calculate for CURRENT Addresses
		WHEN a.RefAddressStatusId = 1 AND a.ResidentFromDate  IS NOT NULL AND a.ResidentFromDate <= @CurrentUserDate
		THEN factfind.dbo.FnDifferenceTotalMonths(a.ResidentFromDate, @CurrentUserDate) 
	END AS TimeAtAddress,
	a.IsRegisteredOnElectoralRoll,
	ISNULL(st.AddressStatus,'') AS AddressStatus
FROM crm..TAddress a
JOIN policymanagement.dbo.FnSplit(@CRMContactIds, ',') parslist ON parslist.Value = a.CRMContactId
JOIN crm..TCRMContact c ON c.CRMContactId = a.CRMContactId
LEFT JOIN crm..TPerson p ON p.PersonId = c.PersonId
JOIN crm..TAddressStore s ON a.AddressStoreId = s.AddressStoreId
LEFT JOIN crm..TRefCounty county ON county.RefCountyId = s.RefCountyId
LEFT JOIN crm..TRefCountry country ON country.RefCountryId = s.RefCountryId
left join TRefAddressStatus st ON a.RefAddressStatusId = st.RefAddressStatusId

WHERE a.IndClientId = @TenantId