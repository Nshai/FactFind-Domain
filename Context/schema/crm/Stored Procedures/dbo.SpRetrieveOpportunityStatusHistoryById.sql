SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveOpportunityStatusHistoryById]
	@OpportunityStatusHistoryId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.OpportunityStatusHistoryId AS [OpportunityStatusHistory!1!OpportunityStatusHistoryId], 
	T1.OpportunityId AS [OpportunityStatusHistory!1!OpportunityId], 
	T1.OpportunityStatusId AS [OpportunityStatusHistory!1!OpportunityStatusId], 
	CONVERT(varchar(24), T1.DateOfChange, 120) AS [OpportunityStatusHistory!1!DateOfChange], 
	T1.ChangedByUserId AS [OpportunityStatusHistory!1!ChangedByUserId], 
	T1.CurrentStatusFG AS [OpportunityStatusHistory!1!CurrentStatusFG], 
	T1.ConcurrencyId AS [OpportunityStatusHistory!1!ConcurrencyId]
	FROM TOpportunityStatusHistory T1
	
	WHERE OpportunityStatusHistoryId = @OpportunityStatusHistoryId
	ORDER BY [OpportunityStatusHistory!1!OpportunityStatusHistoryId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
