SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveClientOpportunities]
	@cid bigint
AS
SELECT	
	ot.OpportunityTypeName as [Type],
	ISNULL(o.Amount,0) as [Value],
	ISNULL(o.Probability, 0) as [Probability],
	os.OpportunityStatusName as [Status],
	ISNULL(o.Amount,0) as [ProbableValue]
FROM 
	TOpportunity o
	JOIN TOpportunityCustomer OC ON OC.OpportunityId = o.OpportunityId AND OC.PartyId = @cid
	JOIN TOpportunityStatusHistory osh ON osh.OpportunityId = o.OpportunityId
	JOIN TOpportunityStatus os ON os.OpportunityStatusId = osh.OpportunityStatusId
	JOIN TOpportunityType ot ON ot.OpportunityTypeId = o.OpportunityTypeId
WHERE 
	osh.CurrentStatusFg = 1
	AND o.IsClosed = 0
	ORDER BY o.CreatedDate Asc





GO
