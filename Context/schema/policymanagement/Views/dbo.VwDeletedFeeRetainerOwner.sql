SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedFeeRetainerOwner]
AS
  SELECT 
    FeeRetainerOwnerId, 
    'AuditId' = MAX(AuditId)
  FROM TFeeRetainerOwnerAudit
  WHERE StampAction = 'D'
  GROUP BY FeeRetainerOwnerId


GO
