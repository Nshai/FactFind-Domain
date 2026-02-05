SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedUser]
AS
  SELECT 
    UserId, 
    'AuditId' = MAX(AuditId)
  FROM TUserAudit
  WHERE StampAction = 'D'
  GROUP BY UserId

GO
