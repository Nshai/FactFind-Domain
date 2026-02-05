SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpCustomRetrievePolicyBusinessWithStatusAndStartDateAndPolicyNumber] @policybusinessid bigint

as

select 1 as tag,
null as parent,
a.policybusinessid as [PolicyBusiness!1!PolicyBusinessId],
a.policynumber as [PolicyBusiness!1!PolicyNumber],
c.[Name] as [PolicyBusiness!1!Status],
ISNULL(Convert(varchar(12),b.ChangedToDate,103),CONVERT(varchar(12),b.DateOfChange)) as [PolicyBusiness!1!MinPolicyStartDate],
ISNULL(CONVERT(varchar(12),a.PolicyStartDate,103),Convert(varchar(12),b.ChangedToDate,103)) as [PolicyBusiness!1!PolicyStartDate]

from policymanagement..tpolicybusiness a
inner join tstatushistory b on a.policybusinessid=b.policybusinessid
inner join tstatus c on b.statusid=c.statusid

where a.policybusinessid=@policybusinessid
and b.CurrentStatusFg=1

order by [PolicyBusiness!1!PolicyBusinessId]

for xml explicit

GO
