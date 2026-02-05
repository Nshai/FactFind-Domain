SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedCheckListRule]
AS
  SELECT 
    CheckListRuleId, 
    'AuditId' = MAX(AuditId)
  FROM TCheckListRuleAudit
  WHERE StampAction = 'D'
  GROUP BY CheckListRuleId


GO
