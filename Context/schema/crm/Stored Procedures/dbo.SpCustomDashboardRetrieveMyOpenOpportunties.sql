SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[nio_SpCustomDashboardRetrieveMyOpenOpportunities]
	@UserId BIGINT,
	@TenantId BIGINT
AS  
  

SELECT S.OpportunityStatusId as StatusId,
	S.OpportunityStatusName as [Status],
	COUNT(DISTINCT O.OpportunityId) as Number
	
FROM TOpportunity O WITH(NOLOCK)	
	INNER JOIN TPractitioner p ON O.PractitionerId = p.PractitionerId
	INNER JOIN administration..TUser U ON U.CRMContactId = P.CRMContactId
	INNER JOIN TOpportunityStatusHistory OSH ON OSH.OpportunityId = O.OpportunityId AND OSH.CurrentStatusFg = 1
	INNER JOIN TOpportunityStatus S ON S.OpportunityStatusId = OSH.OpportunityStatusId

	INNER JOIN CRM..TOpportunityCustomer OC on OC.OpportunityId = O.OpportunityId
	INNER JOIN CRM..TCRMContact C WITH(NOLOCK) ON OC.PartyId = C.CRMContactId

WHERE O.IndigoClientId = @TenantID
	AND P.IndClientId = @TenantID
	AND U.IndigoClientId = @TenantID
	AND U.UserId=@UserId
	AND S.OpportunityStatusTypeId = 1 -- Open Opportunities
	AND C.ArchiveFg = 0 

GROUP BY S.OpportunityStatusId,
	S.OpportunityStatusName,
	S.InitialStatusFG

HAVING COUNT(O.OpportunityId) > 0

ORDER BY S.InitialStatusFG Desc


GO
