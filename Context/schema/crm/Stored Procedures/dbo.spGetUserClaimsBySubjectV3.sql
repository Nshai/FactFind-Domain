SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--exec [spGetUserClaimsBySubject] '61C7E954-4D8F-4D7E-9E33-A48400A56AD0', 28000

CREATE procedure [dbo].[spGetUserClaimsBySubjectV3]
@Subject uniqueidentifier
as

-- fetch Roles
Declare @Roles AS Nvarchar(MAX)
Declare @RoleIds AS Nvarchar(MAX)

select @Roles = COALESCE(@Roles + ', ', '') + r.Identifier, @RoleIds = COALESCE(@RoleIds + ', ', '') + CAST(r.RoleId as varchar(15))
from administration..TMembership m 
left join administration..TRole r on r.RoleId = m.RoleId
left join administration..TUser u with(nolock) on u.UserId = m.UserId
where u.[Guid] = @Subject

select top 1
u.Guid as 'Subject', 
u.UserId as 'UserId',
u.Guid as 'UserGuid',
t.IndigoClientId as 'TenantId', 
t.Guid as 'TenantGuid', 
c.CRMContactId as 'PartyId',
adviser.PractitionerId as 'AdviserId',
servicingAdviser.PractitionerId as 'ServicingAdviserId',
lead.LeadId as 'LeadId',
client.CRMContactId as 'ClientId',
GroupId = 
CASE 
	WHEN u.RefUserTypeId = 4 THEN
								CASE
									WHEN c.GroupId IS NOT NULL AND c.GroupId != 0 THEN c.GroupId
									ELSE advU.GroupId 
								END
	ELSE u.GroupId
END,
u.ActiveRole as 'RoleId',
CONCAT_WS(', ',
            @Roles,
            CASE WHEN u.SuperUser = 1 THEN 'SuperUser' END,
            CASE WHEN u.SuperViewer = 1 THEN 'SuperViewer' END
          ) AS 'Roles',
CONCAT_WS(', ',
            @RoleIds,
            CASE WHEN u.SuperUser = 1 THEN '-1' END,
            CASE WHEN u.SuperViewer = 1 THEN '-2' END
          ) AS 'RoleIds',
u.Identifier as 'Username', 
CASE WHEN u.EmailConfirmed = 1 THEN u.[Email] ELSE NULL END as 'Email',
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
ISNULL(ub.HourlyBillingRate, r.HourlyBillingRate) as 'HourlyBillingRate',
c.RefServiceStatusId as 'ServiceStatusId',
rc.CountryCode as 'Region'

from administration..TUser u with(nolock)
inner join administration..TIndigoClient t on u.IndigoClientId = t.IndigoClientId
left join TCRMContact c on u.CRMContactId = c.CRMContactId
left join administration..TUserBilling ub on u.UserId = ub.UserId
left join administration..TRole r on u.ActiveRole = r.RoleId

left join TPerson p on c.PersonId = p.PersonId
left join administration..TUser advU on advU.CRMContactId = c.CurrentAdviserCRMId
left join TRefCountry rc on rc.RefCountryId = t.Country

OUTER APPLY  (select top 1 * from TContact ct where ct.CRMContactId = c.CRMContactId and ct.RefContactType = 'Telephone') AS telephone
OUTER APPLY  (select top 1 * from TContact ct where ct.CRMContactId = c.CRMContactId and ct.RefContactType = 'Mobile') AS mobile
OUTER APPLY  (select top 1 ads.* from TAddress ad 
		left join TAddressStore ads on ad.AddressStoreId = ads.AddressStoreId
		where ad.CRMContactId = c.CRMContactId and ad.DefaultFg = 1
		) as adddressStore
OUTER APPLY (select top 1 p.PractitionerId 
                from TPractitioner p 
                where p.CRMContactId = c.CRMContactId and p.IndClientId = c.IndClientId) as adviser
OUTER APPLY (select top 1 p.PractitionerId 
                from TPractitioner p 
                where p.CRMContactId = c.CurrentAdviserCRMId and p.IndClientId = c.IndClientId) as servicingAdviser
OUTER APPLY (select top 1 l.LeadId 
                from TLead l 
                where l.CRMContactId = c.CRMContactId and l.IndigoClientId = c.IndClientId) as lead
OUTER APPLY (select top 1 outerclient.CRMContactId 
                from TCRMContact outerclient 
                where outerclient.RefCRMContactStatusId = 1 and outerclient.CRMContactId = c.CRMContactId
                and outerClient.IndClientId = c.IndClientId) as client

WHERE u.Guid = @Subject


GO
