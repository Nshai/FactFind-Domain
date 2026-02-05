SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefPlanActionStatusRoleById]
	@RefPlanActionStatusRoleId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.RefPlanActionStatusRoleId AS [RefPlanActionStatusRole!1!RefPlanActionStatusRoleId], 
	T1.LifeCycleStepId AS [RefPlanActionStatusRole!1!LifeCycleStepId], 
	T1.RefPlanActionId AS [RefPlanActionStatusRole!1!RefPlanActionId], 
	T1.RoleId AS [RefPlanActionStatusRole!1!RoleId], 
	T1.ConcurrencyId AS [RefPlanActionStatusRole!1!ConcurrencyId]
	FROM TRefPlanActionStatusRole T1
	
	WHERE T1.RefPlanActionStatusRoleId = @RefPlanActionStatusRoleId
	ORDER BY [RefPlanActionStatusRole!1!RefPlanActionStatusRoleId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
