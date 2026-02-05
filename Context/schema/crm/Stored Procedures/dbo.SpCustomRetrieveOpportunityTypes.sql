SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveOpportunityTypes] 
	@IndigoClientId bigint, 
	@ShowArchivedItems bit  
AS     
SELECT  
    1 AS Tag,  
    NULL AS Parent,  
    T1.OpportunityTypeId AS [OpportunityType!1!OpportunityTypeId],   
    T1.OpportunityTypeName AS [OpportunityType!1!OpportunityTypeName],   
    T1.IndigoClientId AS [OpportunityType!1!IndigoClientId],   
    T1.ArchiveFG AS [OpportunityType!1!ArchiveFG], 
	T1.SystemFG AS  [OpportunityType!1!SystemFG], 
	T1.InvestmentDefault AS  [OpportunityType!1!InvestmentDefault], 
	T1.RetirementDefault AS  [OpportunityType!1!RetirementDefault], 
    T1.ConcurrencyId AS [OpportunityType!1!ConcurrencyId],  	
    CASE 
		WHEN InUse.OpportunityTypeId IS NULL THEN 0
		ELSE 1
    END AS [OpportunityType!1!IsOpportunityTypeUsed]   
FROM
	TOpportunityType T1 
	LEFT JOIN (
		SELECT DISTINCT
			OpportunityTypeId 
		FROM
			TOpportunity
		WHERE
			IndigoClientId = @IndigoClientId) AS InUse ON InUse.OpportunityTypeId = T1.OpportunityTypeId	
WHERE 
	T1.IndigoClientId = @IndigoClientId 
	AND (@ShowArchivedItems = 1 OR (@ShowArchivedItems = 0 AND T1.ArchiveFG = 0))
ORDER BY 
	[OpportunityType!1!OpportunityTypeId]  
FOR XML EXPLICIT
GO
