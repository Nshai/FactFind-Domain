SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefChangeBasisType]
AS
  SELECT 
    RefChangeBasisTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefChangeBasisTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefChangeBasisTypeId


GO
