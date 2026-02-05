SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedLogon]
AS
  SELECT 
    LogonId, 
    'AuditId' = MAX(AuditId)
  FROM TLogonAudit
  WHERE StampAction = 'D'
  GROUP BY LogonId

GO
