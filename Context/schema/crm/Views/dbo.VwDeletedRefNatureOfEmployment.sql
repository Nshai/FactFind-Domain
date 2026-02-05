SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefNatureOfEmployment]
AS
  SELECT 
    RefNatureOfEmploymentId, 
    'AuditId' = MAX(AuditId)
  FROM TRefNatureOfEmploymentAudit
  WHERE StampAction = 'D'
  GROUP BY RefNatureOfEmploymentId


GO
