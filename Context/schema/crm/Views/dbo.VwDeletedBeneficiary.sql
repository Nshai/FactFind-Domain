SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedBeneficiary]
AS
  SELECT 
    BeneficiaryId, 
    'AuditId' = MAX(AuditId)
  FROM TBeneficiaryAudit
  WHERE StampAction = 'D'
  GROUP BY BeneficiaryId


GO
