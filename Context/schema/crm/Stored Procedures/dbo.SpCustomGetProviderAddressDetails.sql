SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomGetProviderAddressDetails]
	@ProviderId bigint
AS

SELECT 
1 as tag,
NULL as parent,
a.AddressId as [Address!1!AddressId],
a.CRMContactId as [Address!1!CRMContactId],
a.AddressStoreId as [Address!1!AddressStoreId],
ISNULL(a.AddressTypeName, '') as [Address!1!AddressTypeName],
ISNULL(a.DefaultFg, 0) as [Address!1!DefaultFg],
a.ConcurrencyId as [Address!1!ConcurrencyId],
null as [AddressStore!2!AddressStoreId],
null as [AddressStore!2!AddressLine1],
null as [AddressStore!2!AddressLine2],
null as [AddressStore!2!AddressLine3],
null as [AddressStore!2!AddressLine4],
null as [AddressStore!2!CityTown],
null as [AddressStore!2!Postcode],
null as [AddressStore!2!ConcurrencyId],
null as [ContactAddress!3!ContactAddressId],
null as [ContactAddress!3!ContactId],
null as [ContactAddress!3!AddressId],
null as [Contact!4!ContactId],
null as [Contact!4!RefContactType],
null as [Contact!4!Description],
null as [Contact!4!Value],
null as [Contact!4!DefaultFg],
null as [CRMContact!5!CRMContactId],
null as [CRMContact!5!CorporateId],
null as [CRMContact!5!CorporateName],
null as [RefCounty!6!RefCountyId],
null as [RefCounty!6!CountyName],
null as [RefCountry!7!RefCountryId],
null as [RefCountry!7!CountryName]

from TAddress a
INNER JOIN PolicyManagement..TRefProdProvider p ON a.CRMContactId = p.CRMContactId
WHERE p.RefProdProviderId = @ProviderId

UNION

SELECT
2 as tag,
1 as parent,
a.AddressId,
a.CRMContactId,
a.AddressStoreId,
null,
null,
null,
ast.AddressStoreId,
ISNULL(ast.AddressLine1, ''),
ISNULL(ast.AddressLine2, ''),
ISNULL(ast.AddressLine3, ''),
ISNULL(ast.AddressLine4, ''),
ISNULL(ast.CityTown, ''),
ISNULL(ast.PostCode, ''),
ast.ConcurrencyId,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null

FROM TAddressStore ast
INNER JOIN TAddress a ON a.AddressStoreId = ast.AddressStoreId
INNER JOIN PolicyManagement..TRefProdProvider p ON a.CRMContactId = p.CRMContactId
WHERE p.RefProdProviderId = @ProviderId

UNION

SELECT
3 as tag,
1 as parent,
a.AddressId,
a.CRMContactId,
a.AddressStoreId,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
ISNULL(ca.ContactAddressId, ''),
ISNULL(ca.ContactId, ''),
ISNULL(ca.AddressId, ''),
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null

FROM TContactAddress ca
INNER JOIN TAddress a ON a.AddressId = ca.AddressId
INNER JOIN PolicyManagement..TRefProdProvider p ON a.CRMContactId = p.CRMContactId
WHERE p.RefProdProviderId = @ProviderId

UNION

SELECT
4 as tag,
3 as parent,
a.AddressId,
a.CRMContactId,
a.AddressStoreId,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
ISNULL(ca.ContactAddressId, ''),
null,
null,
ISNULL(c.ContactId, ''),
ISNULL(c.RefContactType, ''),
ISNULL(c.Description, ''),
ISNULL(c.Value, ''),
ISNULL(c.DefaultFg, ''),
null,
null,
null,
null,
null,
null,
null

FROM tContact c
INNER JOIN TContactAddress ca ON c.ContactId = ca.ContactId
INNER JOIN TAddress a ON a.AddressId = ca.AddressId
INNER JOIN PolicyManagement..TRefProdProvider p ON a.CRMContactId = p.CRMContactId
WHERE p.RefProdProviderId = @ProviderId



UNION


SELECT
5 as tag,
1 as parent,
a.AddressId,
a.CRMContactId,
a.AddressStoreId,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
ISNULL(crm.CRMContactId, ''),
ISNULL(crm.CorporateId, ''),
ISNULL(crm.CorporateName, ''),
null,
null,
null,
null

FROM TCRMContact crm
INNER JOIN TAddress a ON a.CRMContactId = crm.CRMContactId
INNER JOIN PolicyManagement..TRefProdProvider p ON a.CRMContactId = p.CRMContactId
WHERE p.RefProdProviderId = @ProviderId

UNION

select
6 as tag,
2 as parent,
a.AddressId,
a.CRMContactId,
a.AddressStoreId,
null,
null,
null,
ast.AddressStoreId,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
cty.refcountyid,
cty.countyname,
null,
null

from trefcounty cty
inner join taddressstore ast on ast.refcountyid = cty.refcountyid
inner join taddress a on a.addressstoreid = ast.addressstoreid
inner join tcrmcontact c on c.crmcontactid = a.crmcontactid
inner join policymanagement..trefprodprovider p on c.crmcontactid = p.crmcontactid
where p.refprodproviderid = @providerid

UNION

select
7 as tag,
2 as parent,
a.AddressId,
a.CRMContactId,
a.AddressStoreId,
null,
null,
null,
ast.AddressStoreId,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
ctry.refcountryid,
ctry.countryname


from trefcountry ctry
inner join taddressstore ast on ast.refcountryid = ctry.refcountryid
inner join taddress a on a.addressstoreid = ast.addressstoreid
inner join tcrmcontact c on c.crmcontactid = a.crmcontactid
inner join policymanagement..trefprodprovider p on c.crmcontactid = p.crmcontactid
where p.refprodproviderid = @providerid


ORDER BY [Address!1!AddressId], [AddressStore!2!AddressStoreId], [ContactAddress!3!ContactAddressId], [Contact!4!ContactId], [RefCounty!6!RefCountyId], [RefCountry!7!RefCountryId]

FOR XML EXPLICIT
GO
