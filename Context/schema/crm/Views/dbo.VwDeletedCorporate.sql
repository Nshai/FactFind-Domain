SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedCorporate]
AS
  SELECT 
    CorporateId, 
    'AuditId' = MAX(AuditId)
  FROM TCorporateAudit
  WHERE StampAction = 'D'
  GROUP BY CorporateId


GO
