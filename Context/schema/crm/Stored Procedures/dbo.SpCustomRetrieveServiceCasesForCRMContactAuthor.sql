SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
create procedure SpCustomRetrieveServiceCasesForCRMContactAuthor
@CRMContactId bigint,
@CRMContactId2 bigint = -1

as 

begin

select 
1 as tag,
null as parent,
ac.AdviceCaseId as [AdviceCase!1!AdviceCaseId],
ac.SequentialRef as [AdviceCase!1!SequentialRef],
ac.CaseName as [AdviceCase!1!CaseName],
convert(varchar(10), isnull(ac.StartDate,''), 103) as [AdviceCase!1!StartDate],
acs.Descriptor as [AdviceCase!1!Status],
c.FirstName + ' ' + c.LastName as [AdviceCase!1!AdviserName],
null as [AdviceCasePlan!2!PolicyBusinessId]
from TAdviceCase ac
join TAdviceCaseStatus acs on acs.AdviceCaseStatusId = ac.StatusId
join tpractitioner p on p.practitionerid = ac.practitionerid
join tcrmcontact c on c.crmcontactid = p.crmcontactid
where ac.CRMContactId in (@CRMContactId, @CRMContactId2) or ac.Owner2PartyId in (@CRMContactId, @CRMContactId2)

union

select 
2 as tag,
1 as parent,
ac.AdviceCaseId,
null,
null,
null,
null,
null,
acp.PolicyBusinessId

from TAdviceCase ac
join TAdviceCasePlan acp on acp.AdviceCaseId = ac.AdviceCaseId
where ac.CRMContactId in (@CRMContactId, @CRMContactId2) or ac.Owner2PartyId in (@CRMContactId, @CRMContactId2)

order by [AdviceCase!1!AdviceCaseId]

for xml explicit

end
