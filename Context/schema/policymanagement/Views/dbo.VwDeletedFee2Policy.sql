SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedFee2Policy]
AS
  SELECT 
    Fee2PolicyId, 
    'AuditId' = MAX(AuditId)
  FROM TFee2PolicyAudit
  WHERE StampAction = 'D'
  GROUP BY Fee2PolicyId


GO
