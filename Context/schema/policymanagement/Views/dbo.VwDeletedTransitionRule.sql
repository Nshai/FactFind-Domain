SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedTransitionRule]
AS
  SELECT 
    TransitionRuleId, 
    'AuditId' = MAX(AuditId)
  FROM TTransitionRuleAudit
  WHERE StampAction = 'D'
  GROUP BY TransitionRuleId

GO
