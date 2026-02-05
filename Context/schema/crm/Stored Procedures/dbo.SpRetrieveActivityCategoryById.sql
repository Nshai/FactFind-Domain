SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveActivityCategoryById]
	@ActivityCategoryId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.ActivityCategoryId AS [ActivityCategory!1!ActivityCategoryId], 
	T1.Name AS [ActivityCategory!1!Name], 
	ISNULL(T1.ActivityCategoryParentId, '') AS [ActivityCategory!1!ActivityCategoryParentId], 
	ISNULL(T1.LifeCycleTransitionId, '') AS [ActivityCategory!1!LifeCycleTransitionId], 
	T1.IndigoClientId AS [ActivityCategory!1!IndigoClientId], 
	T1.ClientRelatedFG AS [ActivityCategory!1!ClientRelatedFG], 
	T1.PlanRelatedFG AS [ActivityCategory!1!PlanRelatedFG], 
	T1.FeeRelatedFG AS [ActivityCategory!1!FeeRelatedFG], 
	T1.RetainerRelatedFG AS [ActivityCategory!1!RetainerRelatedFG], 
	T1.OpportunityRelatedFG AS [ActivityCategory!1!OpportunityRelatedFG], 
	T1.AdviserRelatedFg AS [ActivityCategory!1!AdviserRelatedFg], 
	ISNULL(T1.ActivityEvent, '') AS [ActivityCategory!1!ActivityEvent], 
	ISNULL(T1.RefSystemEventId, '') AS [ActivityCategory!1!RefSystemEventId], 
	ISNULL(T1.TemplateTypeId, '') AS [ActivityCategory!1!TemplateTypeId], 
	ISNULL(T1.TemplateId, '') AS [ActivityCategory!1!TemplateId], 
	T1.ConcurrencyId AS [ActivityCategory!1!ConcurrencyId]
	FROM TActivityCategory T1
	
	WHERE T1.ActivityCategoryId = @ActivityCategoryId
	ORDER BY [ActivityCategory!1!ActivityCategoryId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
