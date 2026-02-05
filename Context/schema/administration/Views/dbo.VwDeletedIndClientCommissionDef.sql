SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedIndClientCommissionDef]
AS
  SELECT 
    IndClientCommissionDefId, 
    'AuditId' = MAX(AuditId)
  FROM TIndClientCommissionDefAudit
  WHERE StampAction = 'D'
  GROUP BY IndClientCommissionDefId


GO
