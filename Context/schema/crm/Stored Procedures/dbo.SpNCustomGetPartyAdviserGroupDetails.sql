
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier                  Issue       Description
----        ---------                 -------     -------------
20240731    Ruby Elizabeth George     SE-6803     Added new Document Designer field - Group Website.
*/
CREATE PROCEDURE [dbo].[SpNCustomGetPartyAdviserGroupDetails]		
	 @PartyIds  VARCHAR(8000),
	 @TenantId BIGINT
AS

BEGIN
DECLARE @PartyList TABLE (PartyId bigint PRIMARY KEY)  
INSERT INTO @PartyList(PartyId)
SELECT parslist.Value FROM policymanagement.dbo.FnSplit(@PartyIds, ',') parslist

DECLARE @Group TABLE (
	GroupId int, 
	PartyId bigint, 
	ParentId int, 
	GroupCRMContactId bigint, 
	AdviserCRMContactId bigint, 
	DocumentFileReference varchar(100), 
	Identifier varchar(max), 
	FSARegNbr varchar(max)
)

INSERT INTO @Group (
	GroupId, 
	PartyId, 
	ParentId, 
	GroupCRMContactId, 
	AdviserCRMContactId, 
	DocumentFileReference, 
	Identifier, 
	FSARegNbr
)
SELECT DISTINCT
	g.GroupId, 
	party.CRMContactId, 
	g.ParentId, 
	g.CRMContactId, 
	adviserUser.CRMContactId, 
	g.DocumentFileReference, 
	g.Identifier, 
	g.FSARegNbr
FROM administration.dbo.TGroup g
JOIN administration.dbo.TUser adviserUser on adviserUser.GroupId = g.GroupId AND adviserUser.IndigoClientId = @TenantId
JOIN crm.dbo.TCRMContact party on party.CurrentAdviserCRMId = adviserUser.CRMContactId AND party.IndClientId = @TenantId
JOIN @PartyList p ON party.CRMContactId= p.PartyId 
WHERE g.IndigoClientId = @TenantId

;WITH cte AS(
	SELECT 
		GroupId AS UserGroupId,
		GroupId, 
		ParentId,
		DocumentFileReference AS OrganisationDocumentFileReference
    FROM @Group t
	UNION ALL
	SELECT 
		c.UserGroupId,
		t.GroupId, 
		t.ParentId, 
		t.DocumentFileReference AS OrganisationDocumentFileReference
    FROM administration.dbo.TGroup t 
	JOIN cte c ON c.ParentId = t.GroupId
	WHERE t.IndigoClientId = @TenantId
)

SELECT DISTINCT
	g.PartyId                   As PartyId,
	g.AdviserCRMContactId       As AdviserPartyId,
	g.GroupId                   As GroupId,
	g.Identifier                As GroupName,
	indigoClient.FSA            AS OrganisationAuthorisationNumber,
	g.FSARegNbr                 AS GroupAuthorisationNumber,
	[address].AddressId         As AddressId,
	[address].AddressTypeName   As AddressTypeName,
	addressstore.AddressLine1   As AddressLine1,
	addressstore.AddressLine2   As AddressLine2,
	addressstore.AddressLine3   As AddressLine3,
	addressstore.AddressLine4   As AddressLine4,
	addressstore.CityTown       As CityTown,
	addressstore.Postcode       As Postcode,
	county.CountyCode           As CountyCode,
	country.CountryCode         As CountryCode,
	telephone.Value             As Telephone,
	email.Value                 As Email,
	fax.Value                   AS Fax,
	groupLogoDoc.DocumentId     AS GroupLogoId,
	orgLogoDoc.DocumentId       AS OrganisationLogoId,
	website.Value               As GroupWebsite

From @Group g

LEFT JOIN  administration.dbo.TIndigoClient indigoClient ON @TenantId = indigoClient.IndigoClientId
LEFT JOIN crm.dbo.TAddress [address] on g.GroupCRMContactId = [address].CRMContactId And [address].DefaultFg = 1 
LEFT JOIN CRM.dbo.TAddressStore addressstore on [address].AddressStoreId = addressstore.AddressStoreId
LEFT JOIN CRM.dbo.TRefCounty county on addressstore.RefCountyId = county.RefCountyId
LEFT JOIN CRM.dbo.TRefCountry country on addressstore.RefCountryId = country.RefCountryId
LEFT JOIN CRM.dbo.TContact telephone on telephone.CRMContactId = g.GroupCRMContactId And telephone.RefContactType = 'Telephone' 
LEFT JOIN CRM.dbo.TContact email on email.CRMContactId = g.GroupCRMContactId And email.RefContactType = 'E-Mail' 
LEFT JOIN CRM.dbo.TContact fax on fax.CRMContactId = g.GroupCRMContactId And fax.RefContactType = 'Fax' 

LEFT JOIN [documentmanagement].dbo.[TDocVersion] groupLogoVersion ON groupLogoVersion.DocVersionId = g.DocumentFileReference AND groupLogoVersion.IndigoClientId = indigoClient.IndigoClientId
LEFT JOIN [documentmanagement].dbo.[TDocument] groupLogoDoc ON groupLogoDoc.DocumentId = groupLogoVersion.DocumentId  AND groupLogoDoc.IndigoClientId = groupLogoVersion.IndigoClientId

LEFT JOIN cte org ON org.UserGroupId = g.GroupId AND org.ParentId IS NULL
LEFT JOIN [documentmanagement].dbo.[TDocVersion] orgLogoVersion ON orgLogoVersion.DocVersionId = org.OrganisationDocumentFileReference AND orgLogoVersion.IndigoClientId = indigoClient.IndigoClientId
LEFT JOIN [documentmanagement].dbo.[TDocument] orgLogoDoc ON orgLogoDoc.DocumentId = orgLogoVersion.DocumentId  AND orgLogoDoc.IndigoClientId = orgLogoVersion.IndigoClientId
LEFT JOIN CRM.dbo.TContact website on website.CRMContactId = g.GroupCRMContactId And website.RefContactType = 'Web Site' And website.DefaultFg = 1
END

	
