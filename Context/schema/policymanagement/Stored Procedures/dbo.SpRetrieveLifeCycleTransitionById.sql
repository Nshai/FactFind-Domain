SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveLifeCycleTransitionById]
	@LifeCycleTransitionId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.LifeCycleTransitionId AS [LifeCycleTransition!1!LifeCycleTransitionId], 
	T1.LifeCycleStepId AS [LifeCycleTransition!1!LifeCycleStepId], 
	T1.ToLifeCycleStepId AS [LifeCycleTransition!1!ToLifeCycleStepId], 
	ISNULL(T1.OrderNumber, '') AS [LifeCycleTransition!1!OrderNumber], 
	ISNULL(T1.Type, '') AS [LifeCycleTransition!1!Type], 
	T1.HideStep AS [LifeCycleTransition!1!HideStep], 
	ISNULL(T1.AddToCommissionsFg, '') AS [LifeCycleTransition!1!AddToCommissionsFg], 
	T1.ConcurrencyId AS [LifeCycleTransition!1!ConcurrencyId]
	FROM TLifeCycleTransition T1
	
	WHERE T1.LifeCycleTransitionId = @LifeCycleTransitionId
	ORDER BY [LifeCycleTransition!1!LifeCycleTransitionId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
