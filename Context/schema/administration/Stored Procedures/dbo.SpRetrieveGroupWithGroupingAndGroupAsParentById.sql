SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveGroupWithGroupingAndGroupAsParentById]
@GroupId bigint
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
    ISNULL(T1.AuthorisationText, '') AS [Group!1!AuthorisationText], 
    T1.ConcurrencyId AS [Group!1!ConcurrencyId], 
    NULL AS [Grouping!2!GroupingId], 
    NULL AS [Grouping!2!Identifier], 
    NULL AS [Grouping!2!ParentId], 
    NULL AS [Grouping!2!IsPayable], 
    NULL AS [Grouping!2!IndigoClientId], 
    NULL AS [Grouping!2!ConcurrencyId], 
    NULL AS [Parent!3!GroupId], 
    NULL AS [Parent!3!Identifier], 
    NULL AS [Parent!3!GroupingId], 
    NULL AS [Parent!3!ParentId], 
    NULL AS [Parent!3!CRMContactId], 
    NULL AS [Parent!3!IndigoClientId], 
    NULL AS [Parent!3!LegalEntity], 
    NULL AS [Parent!3!GroupImageLocation], 
    NULL AS [Parent!3!AcknowledgementsLocation], 
    NULL AS [Parent!3!FinancialYearEnd], 
    NULL AS [Parent!3!ApplyFactFindBranding], 
    NULL AS [Parent!3!VatRegNbr], 
    NULL AS [Parent!3!AuthorisationText], 
    NULL AS [Parent!3!ConcurrencyId]
  FROM TGroup T1

  WHERE (T1.GroupId = @GroupId)

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
    ISNULL(T1.AuthorisationText, ''), 
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
    NULL
  FROM TGrouping T2
  INNER JOIN TGroup T1
  ON T2.GroupingId = T1.GroupingId

  WHERE (T1.GroupId = @GroupId)

  UNION ALL

  SELECT
    3 AS Tag,
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
    ISNULL(T1.AuthorisationText, ''), 
    T1.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T3.GroupId, 
    T3.Identifier, 
    T3.GroupingId, 
    ISNULL(T3.ParentId, ''), 
    ISNULL(T3.CRMContactId, ''), 
    T3.IndigoClientId, 
    T3.LegalEntity, 
    ISNULL(T3.GroupImageLocation, ''), 
    ISNULL(T3.AcknowledgementsLocation, ''), 
    ISNULL(CONVERT(varchar(24), T3.FinancialYearEnd, 120),''), 
    T3.ApplyFactFindBranding, 
    ISNULL(T3.VatRegNbr, ''), 
    ISNULL(T3.AuthorisationText, ''), 
    T3.ConcurrencyId
  FROM TGroup T3
  INNER JOIN TGroup T1
  ON T3.GroupId = T1.ParentId

  WHERE (T1.GroupId = @GroupId)

  ORDER BY [Group!1!GroupId], [Parent!3!GroupId], [Grouping!2!GroupingId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
