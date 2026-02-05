SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveOpportunityObjectiveById]
	@OpportunityObjectiveId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.OpportunityObjectiveId AS [OpportunityObjective!1!OpportunityObjectiveId], 
	ISNULL(T1.OpportunityId, '') AS [OpportunityObjective!1!OpportunityId], 
	ISNULL(T1.ObjectiveId, '') AS [OpportunityObjective!1!ObjectiveId], 
	T1.ConcurrencyId AS [OpportunityObjective!1!ConcurrencyId]
	FROM TOpportunityObjective T1
	
	WHERE T1.OpportunityObjectiveId = @OpportunityObjectiveId
	ORDER BY [OpportunityObjective!1!OpportunityObjectiveId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
