SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefLoanState]
AS
  SELECT 
    RefLoanStateId, 
    'AuditId' = MAX(AuditId)
  FROM TRefLoanStateAudit
  WHERE StampAction = 'D'
  GROUP BY RefLoanStateId


GO
