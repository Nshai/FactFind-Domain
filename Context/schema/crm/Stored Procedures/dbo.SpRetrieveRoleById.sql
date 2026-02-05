SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRoleById]
@RoleId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RoleId AS [Role!1!RoleId], 
    T1.Name AS [Role!1!Name], 
    ISNULL(T1.ParentRoleId, '') AS [Role!1!ParentRoleId], 
    T1.IndClientId AS [Role!1!IndClientId], 
    T1.ConcurrencyId AS [Role!1!ConcurrencyId]
  FROM TRole T1

  WHERE (T1.RoleId = @RoleId)

  ORDER BY [Role!1!RoleId]

  FOR XML EXPLICIT

END
RETURN (0)









GO
