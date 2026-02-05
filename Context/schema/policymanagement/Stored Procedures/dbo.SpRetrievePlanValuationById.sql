SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePlanValuationById]
	@PlanValuationId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.PlanValuationId AS [PlanValuation!1!PlanValuationId], 
	T1.PolicyBusinessId AS [PlanValuation!1!PolicyBusinessId], 
	ISNULL(CONVERT(varchar(24), T1.PlanValue), '') AS [PlanValuation!1!PlanValue], 
	ISNULL(CONVERT(varchar(24), T1.PlanValueDate, 120), '') AS [PlanValuation!1!PlanValueDate], 
	ISNULL(T1.RefPlanValueTypeId, '') AS [PlanValuation!1!RefPlanValueTypeId], 
	ISNULL(T1.WhoUpdatedValue, '') AS [PlanValuation!1!WhoUpdatedValue], 
	ISNULL(CONVERT(varchar(24), T1.WhoUpdatedDateTime, 120), '') AS [PlanValuation!1!WhoUpdatedDateTime], 
	ISNULL(CONVERT(varchar(24), T1.SurrenderTransferValue), '') AS [PlanValuation!1!SurrenderTransferValue], 
	T1.ConcurrencyId AS [PlanValuation!1!ConcurrencyId]
	FROM TPlanValuation T1
	
	WHERE T1.PlanValuationId = @PlanValuationId
	ORDER BY [PlanValuation!1!PlanValuationId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
