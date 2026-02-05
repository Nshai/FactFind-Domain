SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[SpCustomRetrieveValExcludedPlanSummary] as

begin

set nocount on
set transaction isolation level read uncommitted


select advisername, adviseremail, sum(totalmanualexcludedplancount) totalmanualexcludedplancount, sum(totalsystemexcludedplancount) totalsystemexcludedplancount, 
			sum(newmanualexcludedplancount) newmanualexcludedplancount, sum(newsystemexcludedplancount) newsystemexcludedplancount

from
(

select
	crm.firstname + ' ' + crm.lastname as advisername,
	adviseruser.email as adviseremail,	
	sum(case when isnull(excludedbyuserid, sysuser.userid )<> sysuser.userid then 1 else 0 end) as totalmanualexcludedplancount,
	sum(case when isnull(excludedbyuserid, sysuser.userid ) = sysuser.userid then 1 else 0 end) as totalsystemexcludedplancount,
	sum(case when isnull(excludedbyuserid, sysuser.userid ) <> sysuser.userid and emailalertsent = 0 then 1 else 0 end) as newmanualexcludedplancount,
	sum(case when isnull(excludedbyuserid, sysuser.userid ) = sysuser.userid and emailalertsent = 0 then 1 else 0 end) as newsystemexcludedplancount
from 
	tvalexcludedplan ex
	inner join tvalpotentialplan pp on ex.policybusinessid = pp.policybusinessid
	inner join administration..tuser adviseruser on adviseruser.crmcontactid = pp.sellingadvisercrmcontactid and pp.sellingadviserstatus = 'Access Granted'
					inner join crm..tcrmcontact crm on crm.crmcontactid = adviseruser.crmcontactid 
	inner join administration..tuser sysuser on sysuser.indigoclientid = pp.indigoclientid and sysuser.refusertypeid = 5 
	
group by
	adviseruser.crmcontactid,
	adviseruser.userid,
	adviseruser.identifier,
	crm.firstname + ' ' + crm.lastname,
	adviseruser.email,
	sysuser.userid
having
	sum(case when emailalertsent = 0 then 1 else 0 end) > 0

union all

select
	crm.firstname + ' ' + crm.lastname as advisername,
	adviseruser.email as adviseremail,	
	sum(case when isnull(excludedbyuserid, sysuser.userid )<> sysuser.userid then 1 else 0 end) as totalmanualexcludedplancount,
	sum(case when isnull(excludedbyuserid, sysuser.userid ) = sysuser.userid then 1 else 0 end) as totalsystemexcludedplancount,
	sum(case when isnull(excludedbyuserid, sysuser.userid ) <> sysuser.userid and emailalertsent = 0 then 1 else 0 end) as newmanualexcludedplancount,
	sum(case when isnull(excludedbyuserid, sysuser.userid ) = sysuser.userid and emailalertsent = 0 then 1 else 0 end) as newsystemexcludedplancount
from 
	tvalexcludedplan ex
	inner join tvalpotentialplan pp on ex.policybusinessid = pp.policybusinessid
	inner join administration..tuser adviseruser on adviseruser.crmcontactid = pp.ServicingAdviserCRMContactID and 
									pp.SellingAdviserStatus != 'Access Granted'  AND pp.ServicingAdviserStatus = 'Access Granted'
					inner join crm..tcrmcontact crm on crm.crmcontactid = adviseruser.crmcontactid 
	inner join administration..tuser sysuser on sysuser.indigoclientid = pp.indigoclientid and sysuser.refusertypeid = 5 
	
group by
	adviseruser.crmcontactid,
	adviseruser.userid,
	adviseruser.identifier,
	crm.firstname + ' ' + crm.lastname,
	adviseruser.email,
	sysuser.userid
having
	sum(case when emailalertsent = 0 then 1 else 0 end) > 0

) a

group by advisername, adviseremail


set nocount off

end
GO
