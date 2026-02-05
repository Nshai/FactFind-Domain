SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPractitionerKey]
AS
  SELECT 
    PractitionerKeyId, 
    'AuditId' = MAX(AuditId)
  FROM TPractitionerKeyAudit
  WHERE StampAction = 'D'
  GROUP BY PractitionerKeyId

GO
