SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveGroupingWithGroupingAsParentAndRoleThenParentWithGroupAsParentGroupByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.GroupingId AS [Grouping!1!GroupingId], 
    T1.Identifier AS [Grouping!1!Identifier], 
    ISNULL(T1.ParentId, '') AS [Grouping!1!ParentId], 
    T1.IsPayable AS [Grouping!1!IsPayable], 
    T1.IndigoClientId AS [Grouping!1!IndigoClientId], 
    T1.ConcurrencyId AS [Grouping!1!ConcurrencyId], 
    NULL AS [Parent!2!GroupingId], 
    NULL AS [Parent!2!Identifier], 
    NULL AS [Parent!2!ParentId], 
    NULL AS [Parent!2!IsPayable], 
    NULL AS [Parent!2!IndigoClientId], 
    NULL AS [Parent!2!ConcurrencyId], 
    NULL AS [Role!3!RoleId], 
    NULL AS [Role!3!Identifier], 
    NULL AS [Role!3!GroupingId], 
    NULL AS [Role!3!SuperUser], 
    NULL AS [Role!3!IndigoClientId], 
    NULL AS [Role!3!LicensedUserCount], 
    NULL AS [Role!3!Dashboard], 
    NULL AS [Role!3!ShowGroupDashboard], 
    NULL AS [Role!3!ConcurrencyId], 
    NULL AS [ParentGroup!4!GroupId], 
    NULL AS [ParentGroup!4!Identifier], 
    NULL AS [ParentGroup!4!GroupingId], 
    NULL AS [ParentGroup!4!ParentId], 
    NULL AS [ParentGroup!4!CRMContactId], 
    NULL AS [ParentGroup!4!IndigoClientId], 
    NULL AS [ParentGroup!4!LegalEntity], 
    NULL AS [ParentGroup!4!GroupImageLocation], 
    NULL AS [ParentGroup!4!AcknowledgementsLocation], 
    NULL AS [ParentGroup!4!FinancialYearEnd], 
    NULL AS [ParentGroup!4!ApplyFactFindBranding], 
    NULL AS [ParentGroup!4!VatRegNbr], 
    NULL AS [ParentGroup!4!ConcurrencyId]
  FROM TGrouping T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.GroupingId, 
    T1.Identifier, 
    ISNULL(T1.ParentId, ''), 
    T1.IsPayable, 
    T1.IndigoClientId, 
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
    NULL, 
    NULL
  FROM TGrouping T2
  INNER JOIN TGrouping T1
  ON T2.GroupingId = T1.ParentId

  WHERE (T1.IndigoClientId = @IndigoClientId)

  UNION ALL

  SELECT
    3 AS Tag,
    1 AS Parent,
    T1.GroupingId, 
    T1.Identifier, 
    ISNULL(T1.ParentId, ''), 
    T1.IsPayable, 
    T1.IndigoClientId, 
    T1.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T3.RoleId, 
    T3.Identifier, 
    T3.GroupingId, 
    T3.SuperUser, 
    T3.IndigoClientId, 
    T3.LicensedUserCount, 
    ISNULL(T3.Dashboard, ''), 
    ISNULL(T3.ShowGroupDashboard, ''), 
    T3.ConcurrencyId, 
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
    NULL
  FROM TRole T3
  INNER JOIN TGrouping T1
  ON T3.GroupingId = T1.GroupingId

  WHERE (T1.IndigoClientId = @IndigoClientId)

  UNION ALL

  SELECT
    4 AS Tag,
    2 AS Parent,
    T1.GroupingId, 
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
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T4.GroupId, 
    T4.Identifier, 
    T4.GroupingId, 
    ISNULL(T4.ParentId, ''), 
    ISNULL(T4.CRMContactId, ''), 
    T4.IndigoClientId, 
    T4.LegalEntity, 
    ISNULL(T4.GroupImageLocation, ''), 
    ISNULL(T4.AcknowledgementsLocation, ''), 
    ISNULL(CONVERT(varchar(24), T4.FinancialYearEnd, 120),''), 
    T4.ApplyFactFindBranding, 
    ISNULL(T4.VatRegNbr, ''), 
    T4.ConcurrencyId
  FROM TGroup T4
  INNER JOIN TGrouping T2
  ON T4.GroupingId = T2.GroupingId
  INNER JOIN TGrouping T1
  ON T2.GroupingId = T1.ParentId

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [Grouping!1!GroupingId], [Role!3!RoleId], [Parent!2!GroupingId], [ParentGroup!4!GroupId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
