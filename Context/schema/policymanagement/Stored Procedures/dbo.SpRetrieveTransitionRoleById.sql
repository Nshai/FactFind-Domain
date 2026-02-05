SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveTransitionRoleById]
@TransitionRoleId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.TransitionRoleId AS [TransitionRole!1!TransitionRoleId], 
    T1.RoleId AS [TransitionRole!1!RoleId], 
    T1.LifeCycleTransitionId AS [TransitionRole!1!LifeCycleTransitionId], 
    ISNULL(T1.ConcurrencyId, '') AS [TransitionRole!1!ConcurrencyId]
  FROM TTransitionRole T1

  WHERE (T1.TransitionRoleId = @TransitionRoleId)

  ORDER BY [TransitionRole!1!TransitionRoleId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
