SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefSourceOfClientByIndClientId]
@IndClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefSourceOfClientId AS [RefSourceOfClient!1!RefSourceOfClientId], 
    T1.SourceType AS [RefSourceOfClient!1!SourceType], 
    ISNULL(T1.ArchiveFg, '') AS [RefSourceOfClient!1!ArchiveFg], 
    ISNULL(T1.IndClientId, '') AS [RefSourceOfClient!1!IndClientId], 
    T1.ConcurrencyId AS [RefSourceOfClient!1!ConcurrencyId]
  FROM TRefSourceOfClient T1

  WHERE (T1.IndClientId = @IndClientId)

  ORDER BY [RefSourceOfClient!1!RefSourceOfClientId]

  FOR XML EXPLICIT

END
RETURN (0)









GO
