SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefCorporateType]
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefCorporateTypeId AS [RefCorporateType!1!RefCorporateTypeId], 
    ISNULL(T1.TypeName, '') AS [RefCorporateType!1!TypeName], 
    ISNULL(T1.HasCompanyRegFg, '') AS [RefCorporateType!1!HasCompanyRegFg], 
    ISNULL(T1.ArchiveFg, '') AS [RefCorporateType!1!ArchiveFg], 
    T1.ConcurrencyId AS [RefCorporateType!1!ConcurrencyId]
  FROM TRefCorporateType T1

  ORDER BY [RefCorporateType!1!RefCorporateTypeId]

  FOR XML EXPLICIT

END
RETURN (0)









GO
