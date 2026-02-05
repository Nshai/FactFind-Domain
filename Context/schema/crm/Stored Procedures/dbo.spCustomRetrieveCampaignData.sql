SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spCustomRetrieveCampaignData]
@ClientIds varchar(max),
@UserId bigint,
@IsSuperUser bit,
@IsSuperViewer BIT = 0
as

Declare @ParsedValues Table ( Id int, ParsedValue varchar(200) )  
Insert Into @ParsedValues(Id, ParsedValue)
select id, value from  policymanagement.dbo.FnSplit(@ClientIds,',')

SELECT        
c.CRMContactId, 
c.IndClientId AS TenantId, 
c.FirstName, 
person.Salutation,
c.LastName, 
person.Title, 
contact.Value AS Email, 
a.FirstName AS AdviserFirstName, 
a.LastName AS AdviserLastName, 
adviserPerson.Title AS AdviserTitle, 
adviserContact.Value AS AdviserEmail,
adviserTelephone.Value As AdviserTelephone,
adviserMobile.Value As AdviserMobile,
adviserBusiness.Value As AdviserBusiness,
g.GroupId AS GroupId,
gc.CorporateName AS GroupName, 
groupContact.Value AS GroupEmail, 
addressStore.AddressLine1 AS GroupAddressLine1, 
addressStore.AddressLine2 AS GroupAddressLine2, 
addressStore.AddressLine3 AS GroupAddressLine3, 
addressStore.AddressLine4 AS GroupAddressLine4, 
addressStore.CityTown AS GroupCity, 
county.CountyName AS GroupCounty, 
addressStore.Postcode AS GroupPostCode,
uc.FirstName AS UserFirstName,
uc.LastName AS UserLastName,
userPerson.Title AS UserTitle,
u.Email AS UserEmail,
case when len(u.Telephone) > 0 then u.Telephone else userTelephone.Value end As UserTelephone,
userMobile.Value As UserMobile,
userBusiness.Value As UserBusiness

FROM            
crm..TCRMContact AS c 
LEFT JOIN crm..VPerson AS person ON c.CRMContactId = person.CRMContactId 
LEFT JOIN crm..TContact AS contact ON c.CRMContactId = contact.CRMContactId AND contact.RefContactType = 'E-Mail' AND contact.DefaultFg = 1 
LEFT JOIN crm..TCRMContact AS a ON c.CurrentAdviserCRMId = a.CRMContactId 
LEFT JOIN crm..VPerson AS adviserPerson ON a.CRMContactId = adviserPerson.CRMContactId 
LEFT JOIN crm..TContact AS adviserContact ON a.CRMContactId = adviserContact.CRMContactId AND adviserContact.RefContactType = 'E-Mail' AND adviserContact.DefaultFg = 1
LEFT JOIN crm..TContact As adviserTelephone ON a.CRMContactId = adviserTelephone.CRMContactId AND adviserTelephone.RefContactType = 'Telephone' AND adviserTelephone.DefaultFg = 1
LEFT JOIN crm..TContact As adviserMobile ON a.CRMContactId = adviserMobile.CRMContactId AND adviserMobile.RefContactType = 'Mobile' AND adviserMobile.DefaultFg = 1
LEFT JOIN crm..TContact As adviserBusiness ON a.CRMContactId = adviserBusiness.CRMContactId AND adviserBusiness.RefContactType = 'Business' AND adviserBusiness.DefaultFg = 1
INNER JOIN administration..TUser u on u.UserId = @UserId
INNER JOIN crm..TCRMContact uc on u.CRMContactId = uc.CRMContactId
LEFT JOIN crm..TPerson userPerson on uc.PersonId = userPerson.PersonId
LEFT JOIN crm..TContact As userTelephone ON uc.CRMContactId = userTelephone.CRMContactId AND userTelephone.RefContactType = 'Telephone' AND userTelephone.DefaultFg = 1
LEFT JOIN crm..TContact As userMobile ON uc.CRMContactId = userMobile.CRMContactId AND userMobile.RefContactType = 'Mobile' AND userMobile.DefaultFg = 1
LEFT JOIN crm..TContact As userBusiness ON uc.CRMContactId = userBusiness.CRMContactId AND userBusiness.RefContactType = 'Business' AND userBusiness.DefaultFg = 1
LEFT JOIN administration..TGroup g on u.GroupId = g.GroupId
LEFT JOIN crm..TCRMContact gc on g.CRMContactId = gc.CRMContactId
LEFT JOIN crm..TContact AS groupContact ON gc.CRMContactId = groupContact.CRMContactId AND groupContact.RefContactType = 'E-Mail' AND groupContact.DefaultFg = 1 
LEFT JOIN crm..TAddress AS groupAddress ON gc.CRMContactId = groupAddress.CRMContactId AND groupAddress.DefaultFg = 1 
LEFT JOIN crm..TAddressStore AS addressStore ON groupAddress.AddressStoreId = addressStore.AddressStoreId 
LEFT JOIN crm..TRefCounty AS county ON addressStore.RefCountyId = county.RefCountyId
-- Secure clause
LEFT JOIN VwCRMContactKeyByCreatorId TCKey ON TCKey.UserId = @UserId AND TCKey.CreatorId = c._OwnerId
LEFT JOIN VwCRMContactKeyByEntityId TEKey ON TEKey.UserId = @UserId AND TEKey.EntityId = c.CRMContactId  -- Note 
WHERE c.CRMContactId in (Select ParsedValue From @ParsedValues)
and (@IsSuperUser = 1 OR @IsSuperViewer = 1 OR (c._OwnerId=@UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))

GO
