SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefTaskStatus]
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefTaskStatusId AS [RefTaskStatus!1!RefTaskStatusId], 
    T1.Name AS [RefTaskStatus!1!Name], 
    T1.ConcurrencyId AS [RefTaskStatus!1!ConcurrencyId]
  FROM TRefTaskStatus T1

  ORDER BY [RefTaskStatus!1!RefTaskStatusId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
