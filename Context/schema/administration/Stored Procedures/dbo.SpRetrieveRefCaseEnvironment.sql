SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefCaseEnvironment]

AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.RefCaseEnvironmentId AS [RefCaseEnvironment!1!RefCaseEnvironmentId], 
	T1.CaseEnvironmentName AS [RefCaseEnvironment!1!CaseEnvironmentName], 
	T1.ConcurrencyId AS [RefCaseEnvironment!1!ConcurrencyId]
	FROM TRefCaseEnvironment T1
	ORDER BY [RefCaseEnvironment!1!RefCaseEnvironmentId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
