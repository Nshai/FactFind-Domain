SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetRefProdProviderAddressDetails]
    @RefProdProviderId BIGINT,
    @TenantId BIGINT
AS

    IF OBJECT_ID('tempdb..#PolicyProvider') IS NOT NULL
        DROP TABLE #PolicyProvider
    IF OBJECT_ID('tempdb..#ProviderAddress') IS NOT NULL
        DROP TABLE #ProviderAddress
    IF OBJECT_ID('tempdb..#SelectedAddress') IS NOT NULL
        DROP TABLE #SelectedAddress

SELECT
       RefProdProviderId,
       CRMContactId
INTO #PolicyProvider
FROM policymanagement..TRefProdProvider
WHERE RefProdProviderId = @RefProdProviderId

SELECT
       p.RefProdProviderId,
       a.AddressId,
       ads.AddressStoreId,
       ads.AddressLine1,
       ads.AddressLine2,
       ads.AddressLine3,
       ads.AddressLine4,
       ads.CityTown,
       ads.Postcode,
       cnty.CountyCode,
       cntry.CountryCode,
       a.DefaultFg AS IsDefault,
       0 AS IsLocalAddress
INTO #ProviderAddress
FROM crm..TAddress a
JOIN crm..TAddressStore ads ON ads.AddressStoreId = a.AddressStoreId
LEFT JOIN crm..TRefCounty cnty ON cnty.RefCountyId = ads.RefCountyId
LEFT JOIN crm..TRefCountry cntry ON cntry.RefCountryId = ads.RefCountryId
JOIN #PolicyProvider p ON p.CRMContactId = a.CRMContactId

INSERT INTO #ProviderAddress
SELECT
       p.RefProdProviderId,
       a.AddressId,
       ads.AddressStoreId,
       ads.AddressLine1,
       ads.AddressLine2,
       ads.AddressLine3,
       ads.AddressLine4,
       ads.CityTown,
       ads.Postcode,
       cnty.CountyCode,
       cntry.CountryCode,
       a.DefaultFg AS IsDefault,
       1 AS IsLocalAddress
FROM crm..TAddress a
JOIN crm..TAddressStore ads ON ads.AddressStoreId = a.AddressStoreId
LEFT JOIN crm..TRefCounty cnty ON cnty.RefCountyId = ads.RefCountyId
LEFT JOIN crm..TRefCountry cntry ON cntry.RefCountryId = ads.RefCountryId
JOIN crm..TAccount ac ON ac.CRMContactId = a.CRMContactId
JOIN #PolicyProvider p ON p.RefProdProviderId = ac.RefProductProviderId
WHERE ac.IndigoClientId = @TenantId

SELECT TOP 1
       COALESCE(la.AddressId, pa.AddressId, na.AddressId, NULL) AS AddressId
INTO #SelectedAddress
FROM #PolicyProvider pr
LEFT JOIN #ProviderAddress la ON la.IsDefault = 1 AND la.IsLocalAddress = 1
LEFT JOIN #ProviderAddress pa ON pa.IsDefault = 1 AND pa.IsLocalAddress = 0
LEFT JOIN #ProviderAddress na ON na.IsDefault = 0 AND na.IsLocalAddress = 0

SELECT
       pa.RefProdProviderId,
       pa.AddressStoreId,
       pa.AddressLine1,
       pa.AddressLine2,
       pa.AddressLine3,
       pa.AddressLine4,
       pa.CityTown,
       pa.Postcode,
       pa.CountyCode,
       pa.CountryCode
FROM #SelectedAddress sa
JOIN #ProviderAddress pa ON pa.AddressId = sa.AddressId