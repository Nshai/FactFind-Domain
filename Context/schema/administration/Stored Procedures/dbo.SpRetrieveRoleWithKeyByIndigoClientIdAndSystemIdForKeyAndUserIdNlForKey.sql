SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRoleWithKeyByIndigoClientIdAndSystemIdForKeyAndUserIdNlForKey]
@IndigoClientId bigint,
@SystemId bigint,
@UserId bigint
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
    NULL AS [Key!2!KeyId], 
    NULL AS [Key!2!RightMask], 
    NULL AS [Key!2!SystemId], 
    NULL AS [Key!2!UserId], 
    NULL AS [Key!2!RoleId], 
    NULL AS [Key!2!ConcurrencyId]
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
    T2.KeyId, 
    T2.RightMask, 
    T2.SystemId, 
    ISNULL(T2.UserId, ''), 
    ISNULL(T2.RoleId, ''), 
    T2.ConcurrencyId
  FROM TKey T2
  INNER JOIN TRole T1
  ON T2.RoleId = T1.RoleId

  WHERE (T1.IndigoClientId = @IndigoClientId) AND 
        (T2.SystemId = @SystemId) AND 
        (T2.UserId IS NULL)

  ORDER BY [Role!1!RoleId], [Key!2!KeyId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
