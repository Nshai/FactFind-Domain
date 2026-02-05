SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedFundDescription]
AS
  SELECT 
    FundDescriptionId, 
    'AuditId' = MAX(AuditId)
  FROM TFundDescriptionAudit
  WHERE StampAction = 'D'
  GROUP BY FundDescriptionId


GO
