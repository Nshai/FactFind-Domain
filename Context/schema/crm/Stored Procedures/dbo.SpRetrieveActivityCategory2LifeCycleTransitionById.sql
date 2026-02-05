SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveActivityCategory2LifeCycleTransitionById]
@ActivityCategory2LifeCycleTransitionId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.ActivityCategory2LifeCycleTransitionId AS [ActivityCategory2LifeCycleTransition!1!ActivityCategory2LifeCycleTransitionId], 
    T1.LifeCycleTransitionId AS [ActivityCategory2LifeCycleTransition!1!LifeCycleTransitionId], 
    T1.ActivityCategoryId AS [ActivityCategory2LifeCycleTransition!1!ActivityCategoryId], 
    T1.ConcurrencyId AS [ActivityCategory2LifeCycleTransition!1!ConcurrencyId]
  FROM TActivityCategory2LifeCycleTransition T1

  WHERE (T1.ActivityCategory2LifeCycleTransitionId = @ActivityCategory2LifeCycleTransitionId)

  ORDER BY [ActivityCategory2LifeCycleTransition!1!ActivityCategory2LifeCycleTransitionId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
