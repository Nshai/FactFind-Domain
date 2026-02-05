SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedDelegate]
AS
  SELECT 
    DelegateId, 
    'AuditId' = MAX(AuditId)
  FROM TDelegateAudit
  WHERE StampAction = 'D'
  GROUP BY DelegateId


GO
