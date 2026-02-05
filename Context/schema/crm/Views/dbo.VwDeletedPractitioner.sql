SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPractitioner]
AS
  SELECT 
    PractitionerId, 
    'AuditId' = MAX(AuditId)
  FROM TPractitionerAudit
  WHERE StampAction = 'D'
  GROUP BY PractitionerId

GO
