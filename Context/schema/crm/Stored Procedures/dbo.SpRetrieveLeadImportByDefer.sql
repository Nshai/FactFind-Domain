SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveLeadImportByDefer]
@Defer bit
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.LeadImportId AS [LeadImport!1!LeadImportId], 
    ISNULL(T1.Identifier, '') AS [LeadImport!1!Identifier], 
    T1.IndigoClientId AS [LeadImport!1!IndigoClientId], 
    T1.UserId AS [LeadImport!1!UserId], 
    CONVERT(varchar(24), T1.EntryDate, 120) AS [LeadImport!1!EntryDate], 
    T1.FileName AS [LeadImport!1!FileName], 
    T1.FileLocation AS [LeadImport!1!FileLocation], 
    T1.FileUrl AS [LeadImport!1!FileUrl], 
    ISNULL(T1.DocVersionId, '') AS [LeadImport!1!DocVersionId], 
    T1.NumberImported AS [LeadImport!1!NumberImported], 
    T1.NumberFailed AS [LeadImport!1!NumberFailed], 
    T1.NumberDuplicates AS [LeadImport!1!NumberDuplicates], 
    T1.Defer AS [LeadImport!1!Defer], 
    T1.Imported AS [LeadImport!1!Imported], 
    T1.ImportDuplicates AS [LeadImport!1!ImportDuplicates], 
    T1.ConcurrencyId AS [LeadImport!1!ConcurrencyId]
  FROM TLeadImport T1

  WHERE (T1.Defer = @Defer)

  ORDER BY [LeadImport!1!LeadImportId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
