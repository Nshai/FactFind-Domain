SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedClientPlanType]
AS
  SELECT 
    ClientPlanTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TClientPlanTypeAudit
  WHERE StampAction = 'D'
  GROUP BY ClientPlanTypeId


GO
