SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedSelfEmployed]
AS
  SELECT 
    SelfEmployedId, 
    'AuditId' = MAX(AuditId)
  FROM TSelfEmployedAudit
  WHERE StampAction = 'D'
  GROUP BY SelfEmployedId


GO
