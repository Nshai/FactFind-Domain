SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefLoanRepaymentType]
AS
  SELECT 
    RefLoanRepaymentTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefLoanRepaymentTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefLoanRepaymentTypeId


GO
