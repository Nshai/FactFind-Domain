CREATE PROCEDURE [dbo].[SpRetrievePortfolioConstructionWithDocVersionOnDocumentManagementKyDocVersionIdByCRMContactId]
@CRMContactId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.PortfolioConstructionId AS [PortfolioConstruction!1!PortfolioConstructionId], 
    T1.CRMContactId AS [PortfolioConstruction!1!CRMContactId], 
    CONVERT(varchar(24), T1.CreatedDate, 120) AS [PortfolioConstruction!1!CreatedDate], 
    T1.Status AS [PortfolioConstruction!1!Status], 
    ISNULL(T1.DocVersionId, '') AS [PortfolioConstruction!1!DocVersionId], 
    NULL AS [PortfolioConstruction!1!XmlContent], 
    T1.ConcurrencyId AS [PortfolioConstruction!1!ConcurrencyId], 
    NULL AS [DocVersion!2!DocVersionId], 
    NULL AS [DocVersion!2!DocumentId], 
    NULL AS [DocVersion!2!FileExtension], 
    NULL AS [DocVersion!2!FileName], 
    NULL AS [DocVersion!2!FileSize], 
    NULL AS [DocVersion!2!Version], 
    NULL AS [DocVersion!2!DocumentData], 
    NULL AS [DocVersion!2!CRMContactId], 
    NULL AS [DocVersion!2!CreatedDate], 
    NULL AS [DocVersion!2!CreatedByUserId], 
    NULL AS [DocVersion!2!LastUpdatedDate], 
    NULL AS [DocVersion!2!LastUserId], 
    NULL AS [DocVersion!2!CheckedOutByUserId], 
    NULL AS [DocVersion!2!CheckOutDate], 
    NULL AS [DocVersion!2!CheckOutReason], 
    NULL AS [DocVersion!2!CheckInDate], 
    NULL AS [DocVersion!2!IndigoClientId], 
    NULL AS [DocVersion!2!Status], 
    NULL AS [DocVersion!2!LastAction], 
    NULL AS [DocVersion!2!Archived], 
    NULL AS [DocVersion!2!Locked], 
    NULL AS [DocVersion!2!FolderId], 
    NULL AS [DocVersion!2!OriginalFileName], 
    NULL AS [DocVersion!2!IsUrl], 
    NULL AS [DocVersion!2!IsAllocationChanged], 
    NULL AS [DocVersion!2!ConcurrencyId]
  FROM TPortfolioConstruction T1

  WHERE (T1.CRMContactId = @CRMContactId)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.PortfolioConstructionId, 
    T1.CRMContactId, 
    CONVERT(varchar(24), T1.CreatedDate, 120), 
    T1.Status, 
    ISNULL(T1.DocVersionId, ''), 
    NULL, 
    T1.ConcurrencyId, 
    T2.DocVersionId, 
    T2.DocumentId, 
    ISNULL(T2.FileExtension, ''), 
    ISNULL(T2.FileName, ''), 
    ISNULL(T2.FileSize, ''), 
    T2.Version, 
    ISNULL(T2.DocumentData, ''), 
    ISNULL(T2.CRMContactId, ''), 
    ISNULL(CONVERT(varchar(24), T2.CreatedDate, 120),''), 
    ISNULL(T2.CreatedByUserId, ''), 
    ISNULL(CONVERT(varchar(24), T2.LastUpdatedDate, 120),''), 
    ISNULL(T2.LastUserId, ''), 
    ISNULL(T2.CheckedOutByUserId, ''), 
    ISNULL(CONVERT(varchar(24), T2.CheckOutDate, 120),''), 
    ISNULL(T2.CheckOutReason, ''), 
    ISNULL(CONVERT(varchar(24), T2.CheckInDate, 120),''), 
    ISNULL(T2.IndigoClientId, ''), 
    ISNULL(T2.Status, ''), 
    ISNULL(T2.LastAction, ''), 
    ISNULL(T2.Archived, ''), 
    ISNULL(T2.Locked, ''), 
    ISNULL(T2.FolderId, ''), 
    ISNULL(T2.OriginalFileName, ''), 
    T2.IsUrl, 
    T2.IsAllocationChanged, 
    ISNULL(T2.ConcurrencyId, '')
  FROM [DocumentManagement].[dbo].TDocVersion T2
  INNER JOIN TPortfolioConstruction T1
  ON T2.DocVersionId = T1.DocVersionId

  WHERE (T1.CRMContactId = @CRMContactId)

  ORDER BY [PortfolioConstruction!1!PortfolioConstructionId], [DocVersion!2!DocVersionId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
