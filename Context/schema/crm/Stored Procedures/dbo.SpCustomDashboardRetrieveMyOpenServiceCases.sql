SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[nio_SpCustomDashboardRetrieveMyOpenServiceCases]
	@UserId BIGINT,
	@TenantId BIGINT
AS  

	select top 10 ClientId,AdviceCaseId,Client1Name + isnull(Client2Name,'') as ClientName,[Date],[Status]
	from (
		select top 10 
			ac.CRMContactId as ClientId, 
			ac.AdviceCaseId, 

					case
						when cCl.CRMContactType = 1 then (cCl.FirstName+' '+cCl.LastName)
						when cCl.CRMContactType in (2,3,4) then (cCl.CorporateName)
					end as [Client1Name],
		
					 case
						when cCl2.CRMContactType = 1 then (' & '+cCl2.FirstName+' '+cCl2.LastName)
						when cCl2.CRMContactType in (2,3,4) then (' & '+cCl2.CorporateName)
					end as [Client2Name],

			case when  ac.StatusChangedOn is null then ac.StartDate else ac.StatusChangedOn  end as Date,
			s.Descriptor as Status
		from vadvicecase ac with (nolock)
			inner join crm..TCRMContact cAd with (nolock) on cAd.CRMContactId=ac.AdviserCRMContactId
			inner join crm..TCRMContact cCl with (nolock) on cCl.CRMContactId=ac.CRMContactId
	   left outer join crm..TCRMContact cCl2 with (nolock) on cCl2.CRMContactId=ac.Owner2PartyId
			inner join TAdviceCaseStatus s with (nolock)on s.AdviceCaseStatusId =ac.StatusId
			inner join administration..TUser u with (nolock)on u.CRMContactId = cAd.CRMContactId
		where u.UserId=@UserId
			and u.IndigoClientId=@TenantId
			and s.IsComplete =0
			and s.IsAutoClose=0
			and cCl.IsDeleted = 0
		) list
	order by date 
	  
GO


