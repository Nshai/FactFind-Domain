SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefRelationshipTypeLinkById]
@RefRelationshipTypeLinkId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefRelationshipTypeLinkId AS [RefRelationshipTypeLink!1!RefRelationshipTypeLinkId], 
    T1.RefRelTypeId AS [RefRelationshipTypeLink!1!RefRelTypeId], 
    T1.RefRelCorrespondTypeId AS [RefRelationshipTypeLink!1!RefRelCorrespondTypeId], 
    T1.ConcurrencyId AS [RefRelationshipTypeLink!1!ConcurrencyId]
  FROM TRefRelationshipTypeLink T1

  WHERE (T1.RefRelationshipTypeLinkId = @RefRelationshipTypeLinkId)

  ORDER BY [RefRelationshipTypeLink!1!RefRelationshipTypeLinkId]

  FOR XML EXPLICIT

END
RETURN (0)








GO
