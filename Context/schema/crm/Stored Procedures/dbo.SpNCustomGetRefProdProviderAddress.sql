SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetRefProdProviderAddress] @PolicyBusinessIds VARCHAR(8000),
                                                            @TenantId BIGINT
AS
    --declare  @PolicyBusinessIds  VARCHAR(8000)='16, 22',
--	 @TenantId BIGINT = 10155


    IF OBJECT_ID('tempdb..#PolicyProvider') IS NOT NULL
        DROP TABLE #PolicyProvider
    IF OBJECT_ID('tempdb..#ProviderAddress') IS NOT NULL
        DROP TABLE #ProviderAddress
    IF OBJECT_ID('tempdb..#SelectedAddresses') IS NOT NULL
        DROP TABLE #SelectedAddresses

SELECT prv.RefProdProviderId RefProdProviderId,
       prcnt.CRMContactId    CRMContactId,
       prcnt.CorporateName   ProviderName,
       pb.PolicyBusinessId   PolicyBusinessId,
       pb.ProviderAddress    ProviderAddress,
       prv.DTCCIdentifier    DTCCIdentifier,
       0 As                  IsProcessed
INTO #PolicyProvider
FROM policymanagement..TPolicyBusiness pb
         JOIN policymanagement.dbo.FnSplit(@PolicyBusinessIds, ',') parslist ON pb.PolicyBusinessId = parslist.Value
         JOIN policymanagement..TPolicyDetail pd ON pd.PolicyDetailId = pb.PolicyDetailId
         JOIN policymanagement..TPlanDescription pds ON pds.PlanDescriptionId = pd.PlanDescriptionId
         JOIN policymanagement..TRefProdProvider prv ON prv.RefProdProviderId = pds.RefProdProviderId
         JOIN crm..TCRMContact prcnt ON prcnt.CRMContactId = prv.CRMContactId
WHERE pb.IndigoClientId = @TenantId

SELECT p.PolicyBusinessId,
       a.AddressId,
       ads.AddressLine1,
       ads.AddressLine2,
       ads.AddressLine3,
       ads.AddressLine4,
       ads.CityTown,
       ads.Postcode,
       cnty.CountyCode,
       cntry.CountryCode,
       a.DefaultFg IsDefault,
       0           IsMatched,
       0           IsLocalAddress
INTO #ProviderAddress
FROM crm..TAddress a
         JOIN crm..TAddressStore ads ON ads.AddressStoreId = a.AddressStoreId
         LEFT JOIN crm..TRefCounty cnty ON cnty.RefCountyId = ads.RefCountyId
         LEFT JOIN crm..TRefCountry cntry ON cntry.RefCountryId = ads.RefCountryId
         JOIN #PolicyProvider p ON p.CRMContactId = a.CRMContactId

INSERT INTO #ProviderAddress
SELECT p.PolicyBusinessId,
       a.AddressId,
       ads.AddressLine1,
       ads.AddressLine2,
       ads.AddressLine3,
       ads.AddressLine4,
       ads.CityTown,
       ads.Postcode,
       cnty.CountyCode,
       cntry.CountryCode,
       a.DefaultFg IsDefault,
       0           IsMatched,
       1           IsLocalAddress
FROM crm..TAddress a
         JOIN crm..TAddressStore ads ON ads.AddressStoreId = a.AddressStoreId
         LEFT JOIN crm..TRefCounty cnty ON cnty.RefCountyId = ads.RefCountyId
         LEFT JOIN crm..TRefCountry cntry ON cntry.RefCountryId = ads.RefCountryId
         JOIN crm..TAccount ac ON ac.CRMContactId = a.CRMContactId
         JOIN #PolicyProvider p ON p.RefProdProviderId = ac.RefProductProviderId
WHERE ac.IndigoClientId = @TenantId


    WHILE (Exists(SELECT 1
                  FROM #PolicyProvider
                  Where IsProcessed = 0))
        BEGIN
            Declare @PolicyBusinessId BIGInt
            Declare @ProviderAddress Varchar(max)
            Declare @IsDefault bit

            SELECT top 1 @PolicyBusinessId = PolicyBusinessId,
                         @ProviderAddress = ProviderAddress,
                         @IsDefault = @IsDefault
            FROM #PolicyProvider
            WHERE IsProcessed = 0

            IF (ISNULL(@ProviderAddress, '') <> '')
                UPDATE pa
                SET pa.IsMatched = 1,
                    pa.IsDefault = 0
                FROM #ProviderAddress pa
                         JOIN(SELECT DISTINCT PolicyBusinessId,
                                              AddressId
                              FROM #ProviderAddress pa
                                       JOIN policymanagement..FnSplit(@ProviderAddress, ',') pLine1 ON pLine1.Value = pa.AddressLine1
                                       JOIN policymanagement..FnSplit(@ProviderAddress, ',') pPostcode ON pPostcode.Value = pa.Postcode
                              Where pa.PolicyBusinessId = @PolicyBusinessId
                              GROUP BY PolicyBusinessId, AddressId) match
                             ON match.AddressId = pa.AddressId and match.PolicyBusinessId = pa.PolicyBusinessId

            UPDATE #PolicyProvider
            SET IsProcessed = 1
            WHERE PolicyBusinessId = @PolicyBusinessId
        END

SELECT pr.RefProdProviderId,
    pr.CRMContactId,
    pr.ProviderName,
    pr.PolicyBusinessId,
    pr.ProviderAddress,
    pr.DTCCIdentifier,
    IIF(ma.PolicyBusinessId IS NOT NULL, ma.AddressId, 
           IIF(la.PolicyBusinessId IS NOT NULL, la.AddressId, 
               IIF(pa.PolicyBusinessId IS NOT NULL, pa.AddressId, 
                   IIF(na.PolicyBusinessId IS NOT NULL, na.AddressId, NULL)))) AddressId
INTO #SelectedAddresses
FROM #PolicyProvider pr
        LEFT JOIN #ProviderAddress ma ON ma.PolicyBusinessId = pr.PolicyBusinessId AND ma.IsMatched = 1
        LEFT JOIN #ProviderAddress la ON la.PolicyBusinessId = pr.PolicyBusinessId AND la.IsDefault = 1 AND la.IsLocalAddress = 1
        LEFT JOIN #ProviderAddress pa ON pa.PolicyBusinessId = pr.PolicyBusinessId AND pa.IsDefault = 1 AND pa.IsLocalAddress = 0
        LEFT JOIN #ProviderAddress na ON na.PolicyBusinessId = pr.PolicyBusinessId AND na.IsDefault = 0 AND na.IsLocalAddress = 0

SELECT sa.RefProdProviderId,
       sa.CRMContactId,
       sa.ProviderName,
       sa.PolicyBusinessId,
       sa.ProviderAddress,
       sa.DTCCIdentifier,
       pa.AddressId,
       pa.AddressLine1,
       pa.AddressLine2,
       pa.AddressLine3,
       pa.AddressLine4,
       pa.CityTown,
       pa.Postcode,
       pa.CountyCode,
       pa.CountryCode
FROM #SelectedAddresses sa
    LEFT JOIN #ProviderAddress pa ON pa.AddressId = sa.AddressId