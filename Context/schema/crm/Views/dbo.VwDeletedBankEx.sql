SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedBankEx]
AS
  SELECT 
    ExtensibleColumnId, 
    'AuditId' = MAX(AuditId)
  FROM TBankExAudit
  WHERE StampAction = 'D'
  GROUP BY ExtensibleColumnId



GO
