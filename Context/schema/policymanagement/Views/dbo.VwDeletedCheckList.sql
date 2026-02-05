SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedCheckList]
AS
  SELECT 
    CheckListId, 
    'AuditId' = MAX(AuditId)
  FROM TCheckListAudit
  WHERE StampAction = 'D'
  GROUP BY CheckListId


GO
