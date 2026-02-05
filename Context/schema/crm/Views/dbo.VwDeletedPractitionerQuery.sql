SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPractitionerQuery]
AS
  SELECT 
    PractitionerQueryId, 
    'AuditId' = MAX(AuditId)
  FROM TPractitionerQueryAudit
  WHERE StampAction = 'D'
  GROUP BY PractitionerQueryId


GO
