SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveMyTopTenOpenOpps]
	@UserId bigint
AS
select top 10 o.OpportunityId as OpportunityId
	,client.CRMContactId as ClientCrmContactId
	,isnull(client.CorporateName,'') + isnull(client.FirstName,'') + ' ' + isnull(client.LastName,'') as [ClientName]
	,opportunityType.OpportunityTypeName as OpportunityTypeName
	,o.TargetClosedDate as TargetClosedDate
	,o.Amount as IncomeValue
	,CASE WHEN client.RefCRMContactStatusId=2 THEN Convert(bit,1) ELSE Convert(bit,0) END as IsLead
from TOpportunity o
join TOpportunityCustomer oc
	on o.OpportunityId = oc.OpportunityId 
	and (oc.OpportunityCustomerId = (Select min(oc.OpportunityCustomerId) From TOpportunityCustomer oc Where  oc.OpportunityId = o.OpportunityId))
join CRM.dbo.TCRMContact client
         on oc.PartyId = client.CRMContactId
join TPractitioner adviser
	on o.PractitionerId = adviser.PractitionerId
join administration.dbo.TUser adviserOwner
	on adviser._OwnerId = adviserOwner.UserId
join CRM.dbo.[TOpportunityType] opportunityType
	on o.OpportunityTypeId = opportunityType.OpportunityTypeId
where o.IsClosed = 0 and adviserOwner.UserId = @UserId and client.ArchiveFg = 0
ORDER  BY o.TargetClosedDate asc
GO
