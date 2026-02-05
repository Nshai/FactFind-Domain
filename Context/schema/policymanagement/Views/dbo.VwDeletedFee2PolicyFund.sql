SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedFee2PolicyFund]
AS
  SELECT 
    Fee2PolicyFundId, 
    'AuditId' = MAX(AuditId)
  FROM TFee2PolicyFundAudit
  WHERE StampAction = 'D'
  GROUP BY Fee2PolicyFundId


GO
