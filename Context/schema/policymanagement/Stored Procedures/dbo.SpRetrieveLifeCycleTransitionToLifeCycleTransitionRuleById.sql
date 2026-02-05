SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveLifeCycleTransitionToLifeCycleTransitionRuleById]
@LifeCycleTransitionToLifeCycleTransitionRuleId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.LifeCycleTransitionToLifeCycleTransitionRuleId AS [LifeCycleTransitionToLifeCycleTransitionRule!1!LifeCycleTransitionToLifeCycleTransitionRuleId], 
    T1.LifeCycleTransitionId AS [LifeCycleTransitionToLifeCycleTransitionRule!1!LifeCycleTransitionId], 
    T1.LifeCycleTransitionRuleId AS [LifeCycleTransitionToLifeCycleTransitionRule!1!LifeCycleTransitionRuleId], 
    ISNULL(T1.ConcurrencyId, '') AS [LifeCycleTransitionToLifeCycleTransitionRule!1!ConcurrencyId]
  FROM TLifeCycleTransitionToLifeCycleTransitionRule T1

  WHERE (T1.LifeCycleTransitionToLifeCycleTransitionRuleId = @LifeCycleTransitionToLifeCycleTransitionRuleId)

  ORDER BY [LifeCycleTransitionToLifeCycleTransitionRule!1!LifeCycleTransitionToLifeCycleTransitionRuleId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
