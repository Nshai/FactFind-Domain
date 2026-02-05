SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[SpCustomRetrieveValExcludedPlanAlertNotSent] 
		@AdviserEmail varchar(255)
as

begin
	select
		ex.ValExcludedPlanId
	from 
		tvalexcludedplan ex
		inner join tvalpotentialplan pp on ex.policybusinessid = pp.policybusinessid
		inner join administration..tuser adviseruser on adviseruser.crmcontactid = pp.sellingadvisercrmcontactid and pp.sellingadviserstatus = 'Access Granted'
						inner join crm..tcrmcontact crm on crm.crmcontactid = adviseruser.crmcontactid 
		inner join administration..tuser sysuser on sysuser.indigoclientid = pp.indigoclientid and sysuser.refusertypeid = 5 
	where emailalertsent = 0 and adviseruser.email = @AdviserEmail

	union 

	select
		ex.ValExcludedPlanId
	from 
		tvalexcludedplan ex
		inner join tvalpotentialplan pp on ex.policybusinessid = pp.policybusinessid
		inner join administration..tuser adviseruser on adviseruser.crmcontactid = pp.ServicingAdviserCRMContactID and 
										pp.SellingAdviserStatus != 'Access Granted'  AND pp.ServicingAdviserStatus = 'Access Granted'
						inner join crm..tcrmcontact crm on crm.crmcontactid = adviseruser.crmcontactid 
		inner join administration..tuser sysuser on sysuser.indigoclientid = pp.indigoclientid and sysuser.refusertypeid = 5 
	where emailalertsent = 0 and adviseruser.email = @AdviserEmail
end


























GO
