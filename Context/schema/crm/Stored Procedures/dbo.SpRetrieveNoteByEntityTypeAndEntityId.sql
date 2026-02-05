SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveNoteByEntityTypeAndEntityId]
@EntityType varchar (255),
@EntityId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.NoteId AS [Note!1!NoteId], 
    ISNULL(T1.EntityType, '') AS [Note!1!EntityType], 
    ISNULL(T1.EntityId, '') AS [Note!1!EntityId], 
    ISNULL(T1.Notes, '') AS [Note!1!Notes], 
    ISNULL(T1.LatestNote, '') AS [Note!1!LatestNote], 
    T1.ConcurrencyId AS [Note!1!ConcurrencyId]
  FROM TNote T1

  WHERE (T1.EntityType = @EntityType) AND 
        (T1.EntityId = @EntityId)

  ORDER BY [Note!1!NoteId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
