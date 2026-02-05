SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VwAddress]
AS
SELECT
	A.CRMContactId,
	A.IndClientId,
	A.RefAddressTypeId,
	A.AddressTypeName,
	A.DefaultFg,
	Ads.AddressLine1,
	Ads.AddressLine2,
	Ads.AddressLine3,
	Ads.AddressLine4,
	Ads.CityTown,
	Ads.PostCode,
	Cty.RefCountyId,
	Cty.CountyName,
	Ctry.RefCountryId,
	Ctry.CountryName
FROM
	TAddress A WITH(NOLOCK) 
	JOIN TAddressStore Ads WITH(NOLOCK) ON Ads.AddressStoreId = A.AddressStoreId  
	LEFT JOIN TRefCounty Cty WITH(NOLOCK) ON Cty.RefCountyId = Ads.RefCountyId  
	LEFT JOIN CRM..TRefCountry Ctry WITH(NOLOCK) ON Ctry.RefCountryId = Ads.RefCountryId


GO
