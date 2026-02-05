SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[spGetUserClaimsByUserId]
@UserId int,
@CallerUserId int
as

select top 1
u.UserId, 
t.IndigoClientId as 'TenantId', 
u.Guid as 'Subject', 
t.Guid as 'TenantGuid', 
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
u.CRMContactId as 'PartyId', 
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
left join crm..TCRMContact c on u.CRMContactId = c.CRMContactId
left join crm..TPerson p on c.PersonId = p.PersonId
left join administration..TUser advU on advU.CRMContactId = c.CurrentAdviserCRMId

-- Secure clause
LEFT JOIN VwCRMContactKeyByCreatorId TCKey ON TCKey.UserId = @CallerUserId AND TCKey.CreatorId = c._OwnerId
LEFT JOIN VwCRMContactKeyByEntityId TEKey ON TEKey.UserId = @CallerUserId AND TEKey.EntityId = c.CRMContactId  -- Note 

OUTER APPLY  (select top 1 * from crm..TContact ct where ct.CRMContactId = c.CRMContactId and ct.RefContactType = 'E-Mail') AS email
OUTER APPLY  (select top 1 * from crm..TContact ct where ct.CRMContactId = c.CRMContactId and ct.RefContactType = 'Telephone') AS telephone
OUTER APPLY  (select top 1 * from crm..TContact ct where ct.CRMContactId = c.CRMContactId and ct.RefContactType = 'Mobile') AS mobile
OUTER APPLY  (select top 1 ads.* from crm..TAddress ad 
		left join crm..TAddressStore ads on ad.AddressStoreId = ads.AddressStoreId
		where ad.CRMContactId = c.CRMContactId and ad.DefaultFg = 1
		) as adddressStore



WHERE u.UserId = @UserId
and (caller.SuperUser = 1 OR caller.SuperViewer = 1 OR u.UserId=@CallerUserId OR (c._OwnerId=@CallerUserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))

GO
