SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedCheckListRuleItem]
AS
  SELECT 
    CheckListRuleItemId, 
    'AuditId' = MAX(AuditId)
  FROM TCheckListRuleItemAudit
  WHERE StampAction = 'D'
  GROUP BY CheckListRuleItemId


GO
