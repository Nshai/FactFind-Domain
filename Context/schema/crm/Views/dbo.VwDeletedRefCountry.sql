SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefCountry]
AS
  SELECT 
    RefCountryId, 
    'AuditId' = MAX(AuditId)
  FROM TRefCountryAudit
  WHERE StampAction = 'D'
  GROUP BY RefCountryId


GO
