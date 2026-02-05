SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[spGetUserClaimsByUserIdV2]
@UserId int,
@CallerUserId int
as

select top 1
u.Guid as 'Subject', 
u.UserId as 'UserId',
u.Guid as 'UserGuid',
t.IndigoClientId as 'TenantId', 
t.Guid as 'TenantGuid', 
u.CRMContactId as 'PartyId',
adviser.PractitionerId as 'AdviserId',
lead.LeadId as 'LeadId',
client.CRMContactId as 'ClientId',
GroupId = CASE WHEN u.RefUserTypeId = 4 THEN advU.GroupId ELSE u.GroupId END, 
u.ActiveRole as 'RoleId',
u.Identifier as 'Username', 
CASE u.RefUserTypeId WHEN 1 THEN u.[Email] ELSE email.Value END  as 'Email', 
p.FirstName, 
p.LastName, 
p.GenderType as 'Gender',
p.MiddleName, 
p.DOB as 'DateOfBirth', 
p.NINumber, 
p.Salary as 'AnnualSalary', 
adddressStore.Postcode as 'PostalCode', 
telephone.Value as 'TelephoneNumber', 
mobile.Value as 'MobileNumber', 
p.MaidenName, 
c.CurrentAdviserCRMId as 'ServicingAdviserPartyId',
c.CurrentAdviserName as 'ServicingAdviserName',
advU.[Guid] as 'ServicingAdviserSubject',
ISNULL(ub.HourlyBillingRate, r.HourlyBillingRate) as 'HourlyBillingRate'

from 
administration..TUser u
inner join administration..TUser caller on caller.UserId = @CallerUserId
inner join administration..TIndigoClient t on u.IndigoClientId = t.IndigoClientId
left join administration..TUserBilling ub on u.UserId = ub.UserId
left join administration..TRole r on u.ActiveRole = r.RoleId
left join TCRMContact c on u.CRMContactId = c.CRMContactId
left join TPerson p on c.PersonId = p.PersonId
left join administration..TUser advU on advU.CRMContactId = c.CurrentAdviserCRMId

-- Secure clause
LEFT JOIN VwCRMContactKeyByCreatorId TCKey ON TCKey.UserId = @CallerUserId AND TCKey.CreatorId = c._OwnerId
LEFT JOIN VwCRMContactKeyByEntityId TEKey ON TEKey.UserId = @CallerUserId AND TEKey.EntityId = c.CRMContactId  -- Note 

OUTER APPLY  (select top 1 * from TContact ct where ct.CRMContactId = c.CRMContactId and ct.RefContactType = 'E-Mail') AS email
OUTER APPLY  (select top 1 * from TContact ct where ct.CRMContactId = c.CRMContactId and ct.RefContactType = 'Telephone') AS telephone
OUTER APPLY  (select top 1 * from TContact ct where ct.CRMContactId = c.CRMContactId and ct.RefContactType = 'Mobile') AS mobile
OUTER APPLY  (select top 1 ads.* from TAddress ad 
		left join TAddressStore ads on ad.AddressStoreId = ads.AddressStoreId
		where ad.CRMContactId = c.CRMContactId and ad.DefaultFg = 1
		) as adddressStore
OUTER APPLY (select top 1 p.PractitionerId 
                from TPractitioner p 
                where p.CRMContactId = c.CRMContactId and p.IndClientId = c.IndClientId) as adviser
OUTER APPLY (select top 1 l.LeadId 
                from TLead l 
                where l.CRMContactId = c.CRMContactId and l.IndigoClientId = c.IndClientId) as lead
OUTER APPLY (select top 1 outerClient.CRMContactId 
                from TCRMContact outerClient 
                where outerClient.RefCRMContactStatusId = 1 and outerClient.CRMContactId = c.CRMContactId 
                and outerClient.IndClientId = c.IndClientId) as client


WHERE u.UserId = @UserId
and (caller.SuperUser = 1 OR caller.SuperViewer = 1 OR u.UserId=@CallerUserId OR (c._OwnerId=@CallerUserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))

GO
