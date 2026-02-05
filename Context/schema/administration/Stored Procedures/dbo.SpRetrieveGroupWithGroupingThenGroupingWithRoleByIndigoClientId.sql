SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveGroupWithGroupingThenGroupingWithRoleByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.GroupId AS [Group!1!GroupId], 
    T1.Identifier AS [Group!1!Identifier], 
    T1.GroupingId AS [Group!1!GroupingId], 
    ISNULL(T1.ParentId, '') AS [Group!1!ParentId], 
    ISNULL(T1.CRMContactId, '') AS [Group!1!CRMContactId], 
    T1.IndigoClientId AS [Group!1!IndigoClientId], 
    T1.LegalEntity AS [Group!1!LegalEntity], 
    ISNULL(T1.GroupImageLocation, '') AS [Group!1!GroupImageLocation], 
    ISNULL(T1.AcknowledgementsLocation, '') AS [Group!1!AcknowledgementsLocation], 
    ISNULL(CONVERT(varchar(24), T1.FinancialYearEnd, 120),'') AS [Group!1!FinancialYearEnd], 
    T1.ApplyFactFindBranding AS [Group!1!ApplyFactFindBranding], 
    ISNULL(T1.VatRegNbr, '') AS [Group!1!VatRegNbr], 
    T1.ConcurrencyId AS [Group!1!ConcurrencyId], 
    NULL AS [Grouping!2!GroupingId], 
    NULL AS [Grouping!2!Identifier], 
    NULL AS [Grouping!2!ParentId], 
    NULL AS [Grouping!2!IsPayable], 
    NULL AS [Grouping!2!IndigoClientId], 
    NULL AS [Grouping!2!ConcurrencyId], 
    NULL AS [Role!3!RoleId], 
    NULL AS [Role!3!Identifier], 
    NULL AS [Role!3!GroupingId], 
    NULL AS [Role!3!SuperUser], 
    NULL AS [Role!3!IndigoClientId], 
    NULL AS [Role!3!LicensedUserCount], 
    NULL AS [Role!3!Dashboard], 
    NULL AS [Role!3!ShowGroupDashboard], 
    NULL AS [Role!3!ConcurrencyId]
  FROM TGroup T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.GroupId, 
    T1.Identifier, 
    T1.GroupingId, 
    ISNULL(T1.ParentId, ''), 
    ISNULL(T1.CRMContactId, ''), 
    T1.IndigoClientId, 
    T1.LegalEntity, 
    ISNULL(T1.GroupImageLocation, ''), 
    ISNULL(T1.AcknowledgementsLocation, ''), 
    ISNULL(CONVERT(varchar(24), T1.FinancialYearEnd, 120),''), 
    T1.ApplyFactFindBranding, 
    ISNULL(T1.VatRegNbr, ''), 
    T1.ConcurrencyId, 
    T2.GroupingId, 
    T2.Identifier, 
    ISNULL(T2.ParentId, ''), 
    T2.IsPayable, 
    T2.IndigoClientId, 
    T2.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
  FROM TGrouping T2
  INNER JOIN TGroup T1
  ON T2.GroupingId = T1.GroupingId

  WHERE (T1.IndigoClientId = @IndigoClientId)

  UNION ALL

  SELECT
    3 AS Tag,
    2 AS Parent,
    T1.GroupId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T2.GroupingId, 
    T2.Identifier, 
    ISNULL(T2.ParentId, ''), 
    T2.IsPayable, 
    T2.IndigoClientId, 
    T2.ConcurrencyId, 
    T3.RoleId, 
    T3.Identifier, 
    T3.GroupingId, 
    T3.SuperUser, 
    T3.IndigoClientId, 
    T3.LicensedUserCount, 
    ISNULL(T3.Dashboard, ''), 
    ISNULL(T3.ShowGroupDashboard, ''), 
    T3.ConcurrencyId
  FROM TRole T3
  INNER JOIN TGrouping T2
  ON T3.GroupingId = T2.GroupingId
  INNER JOIN TGroup T1
  ON T2.GroupingId = T1.GroupingId

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [Group!1!GroupId], [Grouping!2!GroupingId], [Role!3!RoleId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
