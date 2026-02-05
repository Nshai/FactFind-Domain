SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedFee]
AS
  SELECT 
    FeeId, 
    'AuditId' = MAX(AuditId)
  FROM TFeeAudit
  WHERE StampAction = 'D'
  GROUP BY FeeId


GO
