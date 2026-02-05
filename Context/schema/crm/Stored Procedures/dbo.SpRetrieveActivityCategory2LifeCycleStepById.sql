SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveActivityCategory2LifeCycleStepById]
	@ActivityCategory2LifeCycleStepId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.ActivityCategory2LifeCycleStepId AS [ActivityCategory2LifeCycleStep!1!ActivityCategory2LifeCycleStepId], 
	T1.LifeCycleStepId AS [ActivityCategory2LifeCycleStep!1!LifeCycleStepId], 
	T1.ActivityCategoryId AS [ActivityCategory2LifeCycleStep!1!ActivityCategoryId], 
	T1.ConcurrencyId AS [ActivityCategory2LifeCycleStep!1!ConcurrencyId]
	FROM TActivityCategory2LifeCycleStep T1
	
	WHERE T1.ActivityCategory2LifeCycleStepId = @ActivityCategory2LifeCycleStepId
	ORDER BY [ActivityCategory2LifeCycleStep!1!ActivityCategory2LifeCycleStepId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
