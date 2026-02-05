SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveOpportunityStatuses] @IndigoClientId bigint, @ShowArchivedItems bit
AS
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.OpportunityStatusId AS [OpportunityStatus!1!OpportunityStatusId], 
    T1.OpportunityStatusName AS [OpportunityStatus!1!OpportunityStatusName], 
    T1.IndigoClientId AS [OpportunityStatus!1!IndigoClientId], 
    T1.InitialStatusFG AS [OpportunityStatus!1!InitialStatusFG], 
    T1.ArchiveFG AS [OpportunityStatus!1!ArchiveFG], 
    T1.AutoCloseOpportunityFg AS [OpportunityStatus!1!AutoCloseOpportunityFg],
	T1.OpportunityStatusTypeId AS  [OpportunityStatus!1!OpportunityStatusTypeId], 
	ST.Identifier AS  [OpportunityStatus!1!OpportunityStatusType], 
    T1.ConcurrencyId AS [OpportunityStatus!1!ConcurrencyId],
	CASE 
		WHEN InUse.OpportunityStatusId IS NULL THEN 0
		ELSE 1
    END AS [OpportunityStatus!1!IsOpportunityStatusUsed]
FROM 
	TOpportunityStatus T1
	JOIN TOpportunityStatusType ST ON ST.OpportunityStatusTypeId = T1.OpportunityStatusTypeId
	LEFT JOIN (
		SELECT DISTINCT
			OpportunityStatusId 
		FROM
			TOpportunityStatusHistory OSH
			JOIN TOpportunity O ON O.OpportunityId = OSH.OpportunityId
		WHERE
			O.IndigoClientId = @IndigoClientId) AS InUse ON InUse.OpportunityStatusId = T1.OpportunityStatusId
WHERE 
	T1.IndigoClientId = @IndigoClientId 
	AND (@ShowArchivedItems = 1 OR (@ShowArchivedItems = 0 AND T1.ArchiveFG = 0))
FOR XML EXPLICIT
GO
