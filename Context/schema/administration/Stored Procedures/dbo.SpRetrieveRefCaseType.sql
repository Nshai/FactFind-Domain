SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefCaseType]

AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.RefCaseTypeId AS [RefCaseType!1!RefCaseTypeId], 
	T1.CaseTypeName AS [RefCaseType!1!CaseTypeName], 
	T1.ConcurrencyId AS [RefCaseType!1!ConcurrencyId]
	FROM TRefCaseType T1
	ORDER BY [RefCaseType!1!RefCaseTypeId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
