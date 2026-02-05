SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveOpportunityStatusById]
	@OpportunityStatusId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.OpportunityStatusId AS [OpportunityStatus!1!OpportunityStatusId], 
	T1.OpportunityStatusName AS [OpportunityStatus!1!OpportunityStatusName], 
	T1.IndigoClientId AS [OpportunityStatus!1!IndigoClientId], 
	T1.InitialStatusFG AS [OpportunityStatus!1!InitialStatusFG], 
	T1.ArchiveFG AS [OpportunityStatus!1!ArchiveFG], 
	T1.AutoCloseOpportunityFg AS [OpportunityStatus!1!AutoCloseOpportunityFg], 
	T1.OpportunityStatusTypeId AS [OpportunityStatus!1!OpportunityStatusTypeId], 
	T1.ConcurrencyId AS [OpportunityStatus!1!ConcurrencyId]
	FROM TOpportunityStatus T1
	
	WHERE T1.OpportunityStatusId = @OpportunityStatusId
	ORDER BY [OpportunityStatus!1!OpportunityStatusId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
