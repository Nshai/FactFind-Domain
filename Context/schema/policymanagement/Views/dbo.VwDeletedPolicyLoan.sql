SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyLoan]
AS
  SELECT 
    PolicyLoanId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyLoanAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyLoanId


GO
