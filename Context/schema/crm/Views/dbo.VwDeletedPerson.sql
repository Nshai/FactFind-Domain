SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPerson]
AS
  SELECT 
    PersonId, 
    'AuditId' = MAX(AuditId)
  FROM TPersonAudit
  WHERE StampAction = 'D'
  GROUP BY PersonId


GO
