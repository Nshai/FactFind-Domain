

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetPartyAdviserAddress]		
	 @PartyIds  VARCHAR(8000),
	 @TenantId BIGINT
AS

--DECLARE @TenantId BIGINT = 10155
--DECLARE @PartyIds VARCHAR(8000) = '4670733, 4670731'

SELECT tmp.PartyId					as PartyId,
	   tmp.AdviserPartyId			as AdviserPartyId,
	   tenant.IndigoClientId		as OrganisationId,
       tenant.Identifier			as OrganisationName,      
       addressstore.AddressLine1	as AddressLine1,
       addressstore.AddressLine2	as AddressLine2,
       addressstore.AddressLine3	as AddressLine3,
       addressstore.AddressLine4	as AddressLine4,
       addressstore.CityTown		as CityTown,
	   addressstore.Postcode		as Postcode,
       county.CountyCode			as CountyCode,     
       country.CountryCode			as CountryCode
FROM   CRM.dbo.TAddress [address]
       inner join CRM.dbo.TAddressStore addressstore
         on [address].AddressStoreId = addressstore.AddressStoreId
       left outer join CRM.dbo.TRefCounty county
         on addressstore.RefCountyId = county.RefCountyId
       left outer join CRM.dbo.TRefCountry country
         on addressstore.RefCountryId = country.RefCountryId
       inner join Administration.dbo.[TIndigoClient] tenant
         on [address].IndClientId = tenant.IndigoClientId
       inner join CRM.dbo.TCRMContact addressParty
         on [address].CRMContactId = addressParty.CRMContactId
JOIN  
(
	SELECT adviserParty.CRMContactId AdviserPartyId, 
		   crmContact.CRMContactId PartyId
    FROM   CRM.dbo.TCRMContact crmContact                                       
            JOIN CRM.dbo.VCustomer customer
                ON crmContact.CRMContactId = customer.CRMContactId
            JOIN CRM.dbo.TCRMContact adviserParty
                ON customer.CurrentAdviserCRMId = adviserParty.CRMContactId                                      
            JOIN CRM.dbo.VAdviser adviser
                ON adviserParty.CRMContactId = adviser.CRMContactId
			JOIN policymanagement.dbo.FnSplit(@PartyIds, ',') parslist ON crmContact.CRMContactId= parslist.Value 
    WHERE  crmContact.IndClientId = @TenantId
     
	   ) tmp  ON addressParty.CRMContactId = tmp.AdviserPartyId

Where   tenant.IndigoClientId = @TenantId 
       and [address].DefaultFg = 1 
	