SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefCasePriority]

AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.RefCasePriorityId AS [RefCasePriority!1!RefCasePriorityId], 
	T1.CasePriorityName AS [RefCasePriority!1!CasePriorityName], 
	T1.IsDefectPriority AS [RefCasePriority!1!IsDefectPriority], 
	T1.ConcurrencyId AS [RefCasePriority!1!ConcurrencyId]
	FROM TRefCasePriority T1
	ORDER BY [RefCasePriority!1!RefCasePriorityId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
