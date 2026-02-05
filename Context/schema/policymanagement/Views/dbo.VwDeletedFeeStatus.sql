SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedFeeStatus]
AS
  SELECT 
    FeeStatusId, 
    'AuditId' = MAX(AuditId)
  FROM TFeeStatusAudit
  WHERE StampAction = 'D'
  GROUP BY FeeStatusId


GO
