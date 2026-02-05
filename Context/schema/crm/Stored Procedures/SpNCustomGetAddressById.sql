SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpNCustomGetAddressesByIds]
	@AddressIds VARCHAR(8000)
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT 
	ta.AddressId,
	tas.AddressStoreId,
	tas.AddressLine1,
	tas.AddressLine2,
	tas.AddressLine3,
	tas.AddressLine4,
	tas.CityTown,
	tas.Postcode,
	county.CountyCode,
	country.CountryCode
	FROM TAddress ta
	INNER JOIN TAddressStore tas ON tas.AddressStoreId = ta.AddressStoreId
	LEFT JOIN crm..TRefCounty county ON county.RefCountyId = tas.RefCountyId
	LEFT JOIN crm..TRefCountry country ON country.RefCountryId = tas.RefCountryId
	WHERE ta.AddressId in (SELECT DISTINCT Value AS Id FROM policymanagement.dbo.FnSplit(@AddressIds, ','))

END
GO
