SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- An improved SP of dbo.spGetUserClaimsByPartyId. 
-- Adds reach support. Deprecate and delete dbo.spGetUserClaimsByPartyId.


CREATE procedure [dbo].[spGetUserClaimsByPartyIdAndReach]
@PartyId int,
@CallerUserId int = null,
@CallerTenantId int = null,
@Reach varchar(255) = ''
as

-- if CallerTenantId id is null, and CallerUserId is present, fetch CallerTenantId from aller user
If IsNull(@CallerUserId,0) > 0 and IsNull(@CallerTenantId,0) =0
       Select @CallerTenantId = IndigoClientId from administration..tuser where UserId = @CallerUserId

select top 1
IsNull(findUser.UserId,0) as UserId ,
findParty.IndClientId as 'TenantId', 
findUser.Guid as 'Subject', 
findUser.ActiveRole as 'RoleId', 
t.Guid as 'TenantGuid', 
GroupId = CASE WHEN findUser.RefUserTypeId = 4 THEN advU.GroupId ELSE findUser.GroupId END, 
findUser.Identifier as 'Username', 
CASE findUser.RefUserTypeId WHEN 1 THEN findUser.[Email] ELSE email.Value END  as 'Email', 
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
findParty.CRMContactId as 'PartyId',
findParty.CurrentAdviserCRMId As 'ServicingAdviserPartyId',
findParty.CurrentAdviserName as 'ServicingAdviserName',
advU.[Guid] as 'ServicingAdviserSubject',
ISNULL(ub.HourlyBillingRate, r.HourlyBillingRate) as 'HourlyBillingRate'

from crm..TCRMContact findParty
Left Join administration..TUser findUser On findParty.CRMContactId = findUser.CRMContactId
left join administration..TUser callingUser on callingUser.UserId = @CallerUserId
left join administration..TIndigoClient t on findParty.IndClientId = t.IndigoClientId
left join administration..TUserBilling ub on findUser.UserId = ub.UserId
left join administration..TRole r on findUser.ActiveRole = r.RoleId

left join crm..TPerson p on findParty.PersonId = p.PersonId
left join administration..TUser advU on advU.CRMContactId = findParty.CurrentAdviserCRMId

-- Secure clause
LEFT JOIN VwCRMContactKeyByCreatorId TCKey ON TCKey.UserId = @CallerUserId AND TCKey.CreatorId = findParty._OwnerId 
LEFT JOIN VwCRMContactKeyByEntityId TEKey ON TEKey.UserId = @CallerUserId AND TEKey.EntityId = findParty.CRMContactId 

OUTER APPLY  (select top 1 * from crm..TContact ct where ct.CRMContactId = findParty.CRMContactId and ct.RefContactType = 'E-Mail') AS email
OUTER APPLY  (select top 1 * from crm..TContact ct where ct.CRMContactId = findParty.CRMContactId and ct.RefContactType = 'Telephone') AS telephone
OUTER APPLY  (select top 1 * from crm..TContact ct where ct.CRMContactId = findParty.CRMContactId and ct.RefContactType = 'Mobile') AS mobile
OUTER APPLY  (select top 1 ads.* from crm..TAddress ad 
		left join crm..TAddressStore ads on ad.AddressStoreId = ads.AddressStoreId
		where ad.CRMContactId = findParty.CRMContactId and ad.DefaultFg = 1
		) as adddressStore

WHERE findParty.CRMContactId = @PartyId -- match target party
and ( -- one of severl reach cases:

	-- allow anything for `system`
	(@reach = 'system' )
	Or
	-- for any othe reaach, assert that caller tenant id is same as target party tenant id
	-- add extra check for reach != system. More info: https://blogs.msdn.microsoft.com/bartd/2011/03/03/dont-depend-on-expression-short-circuiting-in-t-sql-not-even-with-case/
	( @Reach <> 'system' AND @CallerTenantId = findParty.IndClientId AND
		(
			-- either reach is tenant or super user.
			@reach = 'tenant'  or callingUser.SuperUser = 1 OR callingUser.SuperViewer = 1 
			-- or target party is the caller user 
			OR findUser.UserId=@CallerUserId 
			-- or target party owner is the caller user
			OR findParty._OwnerId=@CallerUserId 
			
			-- apply entity security
			-- or creator ID is not null 
			OR TCKey.CreatorId IS NOT NULL 
			-- or entity id is not null
			OR TEKey.EntityId IS NOT NULL
			
		)
	)
)

GO
