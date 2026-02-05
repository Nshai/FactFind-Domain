SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefLoanType]
AS
  SELECT 
    RefLoanTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefLoanTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefLoanTypeId


GO
