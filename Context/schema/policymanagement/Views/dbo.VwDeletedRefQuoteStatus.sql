SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefQuoteStatus]
AS
  SELECT 
    RefQuoteStatusId, 
    'AuditId' = MAX(AuditId)
  FROM TRefQuoteStatusAudit
  WHERE StampAction = 'D'
  GROUP BY RefQuoteStatusId


GO
