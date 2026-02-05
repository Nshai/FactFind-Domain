SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedOutGoingJoint]
AS
  SELECT 
    OutGoingJointId, 
    'AuditId' = MAX(AuditId)
  FROM TOutGoingJointAudit
  WHERE StampAction = 'D'
  GROUP BY OutGoingJointId


GO
