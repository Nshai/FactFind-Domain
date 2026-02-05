SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveOpportunityTypeById]
	@OpportunityTypeId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.OpportunityTypeId AS [OpportunityType!1!OpportunityTypeId], 
	T1.OpportunityTypeName AS [OpportunityType!1!OpportunityTypeName], 
	T1.IndigoClientId AS [OpportunityType!1!IndigoClientId], 
	T1.ArchiveFG AS [OpportunityType!1!ArchiveFG], 
	T1.SystemFG AS [OpportunityType!1!SystemFG], 
	T1.InvestmentDefault AS [OpportunityType!1!InvestmentDefault], 
	T1.RetirementDefault AS [OpportunityType!1!RetirementDefault], 
	T1.ConcurrencyId AS [OpportunityType!1!ConcurrencyId]
	FROM TOpportunityType T1
	
	WHERE T1.OpportunityTypeId = @OpportunityTypeId
	ORDER BY [OpportunityType!1!OpportunityTypeId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
