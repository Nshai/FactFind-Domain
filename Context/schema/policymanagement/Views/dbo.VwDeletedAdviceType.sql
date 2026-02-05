SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAdviceType]
AS
  SELECT 
    AdviceTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TAdviceTypeAudit
  WHERE StampAction = 'D'
  GROUP BY AdviceTypeId


GO
