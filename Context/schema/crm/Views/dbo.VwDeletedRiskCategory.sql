SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRiskCategory]
AS
  SELECT 
    RiskCategoryId, 
    'AuditId' = MAX(AuditId)
  FROM TRiskCategoryAudit
  WHERE StampAction = 'D'
  GROUP BY RiskCategoryId


GO
