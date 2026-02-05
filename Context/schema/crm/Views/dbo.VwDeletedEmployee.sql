SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedEmployee]
AS
  SELECT 
    EmployeeId, 
    'AuditId' = MAX(AuditId)
  FROM TEmployeeAudit
  WHERE StampAction = 'D'
  GROUP BY EmployeeId


GO
