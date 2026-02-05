CREATE PROCEDURE [dbo].[SpNCustomRetrievePartyPropertyDetails] 
(
  @CRMContactId BIGINT,                            
  @CRMContactId2 BIGINT,                       
  @TenantId bigint
)
As

--DECLARE @CRMContactId BIGINT = 4670733
--DECLARE @CRMContactId2 BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155

WITH PropertyDetails AS (
SELECT PropertyDetailId, PropertyType, PropertyStatus, RelatedAddressStoreId, TenureType, LeaseholdEndsOn, Construction, CertificateNotes,
			 RoofConstructionType, NumberOfBedrooms, YearBuilt, IsNewBuild, NHBCCertificateCovered, OtherCertificateCovered,
			 BuilderName, IsExLocalAuthority, NumberOfOutbuildings, CRMContactId,
			 RefAdditionalPropertyDetailId, ROW_NUMBER() OVER (PARTITION BY RelatedAddressStoreId
															   ORDER BY PROPERTYDETAILID) AS row_num
FROM factfind..TPropertyDetail)
SELECT
 p.PropertyDetailId,
 ISNULL(c.FirstName, '') + ' ' + ISNULL(c.LastName, '') [Addressee],
 p.RelatedAddressStoreId AddressStoreId,
 addr.AddressLine1 AddressLine1,
 addr.AddressLine2 AddressLine2,
 addr.AddressLine3 AddressLine3,
 addr.AddressLine4 AddressLine4,
 addr.CityTown CityTown,
 acn.CountyCode CountyCode,
 acnt.CountryCode CountryCode,
 addr.Postcode PostCode,
 a.AddressTypeName AddressType,
 refAS.AddressStatus,
 p.PropertyType,
 a.TenureType,
 p.LeaseholdEndsOn,
 a.PropertyStatus,
 p.Construction,
 p.RoofConstructionType,
 p.NumberOfBedrooms,
 p.YearBuilt,
 p.IsNewBuild,
 p.NHBCCertificateCovered,
 p.OtherCertificateCovered,
 p.CertificateNotes,
 p.BuilderName,
 p.IsExLocalAuthority,
 p.NumberOfOutbuildings,
 pd.[Description] PropertyAdditionalDetails
FROM crm..TAddress a
JOIN PropertyDetails p on a.AddressStoreId = p.RelatedAddressStoreId and row_num = 1
JOIN crm..TCRMContact c on c.CRMContactId = a.CRMContactId
JOIN crm..TAddressStore addr ON addr.AddressStoreId = p.RelatedAddressStoreId and addr.AddressLine1 is not null
LEFT JOIN crm..TRefAddressStatus refAS on refAS.RefAddressStatusId = a.RefAddressStatusId
LEFT JOIN crm..TRefCounty acn ON acn.RefCountyId = addr.RefCountyId
LEFT JOIN crm..TRefCountry acnt ON acnt.RefCountryId = addr.RefCountryId
LEFT JOIN factfind..TRefAdditionalPropertyDetail pd ON pd.RefAdditionalPropertyDetailId = p.RefAdditionalPropertyDetailId
WHERE a.CRMContactId IN (@CRMContactId, @CRMContactId2)
