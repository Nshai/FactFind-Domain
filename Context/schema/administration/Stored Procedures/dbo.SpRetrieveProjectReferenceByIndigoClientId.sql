SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveProjectReferenceByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.ProjectReferenceId AS [ProjectReference!1!ProjectReferenceId], 
    T1.ProjectReferenceName AS [ProjectReference!1!ProjectReferenceName], 
    T1.IndigoClientId AS [ProjectReference!1!IndigoClientId], 
    T1.ConcurrencyId AS [ProjectReference!1!ConcurrencyId]
  FROM TProjectReference T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [ProjectReference!1!ProjectReferenceId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
