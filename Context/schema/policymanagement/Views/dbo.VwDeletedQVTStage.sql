SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedQVTStage]
AS
  SELECT 
    QVTStageId, 
    'AuditId' = MAX(AuditId)
  FROM TQVTStageAudit
  WHERE StampAction = 'D'
  GROUP BY QVTStageId


GO
