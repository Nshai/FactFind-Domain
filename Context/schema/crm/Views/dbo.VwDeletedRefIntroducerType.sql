SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefIntroducerType]
AS
  SELECT 
    RefIntroducerTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefIntroducerTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefIntroducerTypeId


GO
