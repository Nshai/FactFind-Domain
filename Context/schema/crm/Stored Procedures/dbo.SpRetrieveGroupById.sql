SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveGroupById]
@GroupId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.GroupId AS [Group!1!GroupId], 
    ISNULL(T1.IndClientId, '') AS [Group!1!IndClientId], 
    ISNULL(T1.RefGroupTypeId, '') AS [Group!1!RefGroupTypeId], 
    ISNULL(T1.Name, '') AS [Group!1!Name], 
    ISNULL(T1.CRMContactId, '') AS [Group!1!CRMContactId], 
    ISNULL(T1.Reference, '') AS [Group!1!Reference], 
    ISNULL(T1.ParentGroupId, '') AS [Group!1!ParentGroupId], 
    ISNULL(T1.RetiredFG, '') AS [Group!1!RetiredFG], 
    ISNULL(T1.Notes, '') AS [Group!1!Notes], 
    ISNULL(T1.ConcurrencyId, '') AS [Group!1!ConcurrencyId]
  FROM TGroup T1

  WHERE (T1.GroupId = @GroupId)

  ORDER BY [Group!1!GroupId]

  FOR XML EXPLICIT

END
RETURN (0)









GO
