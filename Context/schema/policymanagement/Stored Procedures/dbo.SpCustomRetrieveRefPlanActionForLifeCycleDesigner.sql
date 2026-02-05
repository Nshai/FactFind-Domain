SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveRefPlanActionForLifeCycleDesigner]

AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.RefPlanActionId AS [RefPlanAction!1!RefPlanActionId], 
	T1.Identifier AS [RefPlanAction!1!Identifier], 
	T1.Description AS [RefPlanAction!1!Description], 
	T1.ConcurrencyId AS [RefPlanAction!1!ConcurrencyId]
	FROM TRefPlanAction T1
	WHERE T1.HideFromLifeCycleDesigner = 0
	ORDER BY [RefPlanAction!1!RefPlanActionId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
