SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRoleWithGroupingByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RoleId AS [Role!1!RoleId], 
    T1.Identifier AS [Role!1!Identifier], 
    T1.GroupingId AS [Role!1!GroupingId], 
    T1.SuperUser AS [Role!1!SuperUser], 
    T1.IndigoClientId AS [Role!1!IndigoClientId], 
    T1.LicensedUserCount AS [Role!1!LicensedUserCount], 
    ISNULL(T1.Dashboard, '') AS [Role!1!Dashboard], 
    ISNULL(T1.ShowGroupDashboard, '') AS [Role!1!ShowGroupDashboard], 
    T1.ConcurrencyId AS [Role!1!ConcurrencyId], 
    NULL AS [Grouping!2!GroupingId], 
    NULL AS [Grouping!2!Identifier], 
    NULL AS [Grouping!2!ParentId], 
    NULL AS [Grouping!2!IsPayable], 
    NULL AS [Grouping!2!IndigoClientId], 
    NULL AS [Grouping!2!ConcurrencyId]
  FROM TRole T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.RoleId, 
    T1.Identifier, 
    T1.GroupingId, 
    T1.SuperUser, 
    T1.IndigoClientId, 
    T1.LicensedUserCount, 
    ISNULL(T1.Dashboard, ''), 
    ISNULL(T1.ShowGroupDashboard, ''), 
    T1.ConcurrencyId, 
    T2.GroupingId, 
    T2.Identifier, 
    ISNULL(T2.ParentId, ''), 
    T2.IsPayable, 
    T2.IndigoClientId, 
    T2.ConcurrencyId
  FROM TGrouping T2
  INNER JOIN TRole T1
  ON T2.GroupingId = T1.GroupingId

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [Role!1!RoleId], [Grouping!2!GroupingId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
