SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefCaseReason]

AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.RefCaseReasonId AS [RefCaseReason!1!RefCaseReasonId], 
	T1.CaseReasonName AS [RefCaseReason!1!CaseReasonName], 
	T1.ConcurrencyId AS [RefCaseReason!1!ConcurrencyId]
	FROM TRefCaseReason T1
	ORDER BY [RefCaseReason!1!RefCaseReasonId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
