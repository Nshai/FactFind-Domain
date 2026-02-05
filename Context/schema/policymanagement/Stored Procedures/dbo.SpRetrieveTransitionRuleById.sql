SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveTransitionRuleById]
@TransitionRuleId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.TransitionRuleId AS [TransitionRule!1!TransitionRuleId], 
    T1.RuleSPName AS [TransitionRule!1!RuleSPName], 
    T1.LifeCycleTransitionId AS [TransitionRule!1!LifeCycleTransitionId], 
    ISNULL(T1.Alias, '') AS [TransitionRule!1!Alias], 
    ISNULL(T1.ConcurrencyId, '') AS [TransitionRule!1!ConcurrencyId]
  FROM TTransitionRule T1

  WHERE (T1.TransitionRuleId = @TransitionRuleId)

  ORDER BY [TransitionRule!1!TransitionRuleId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
