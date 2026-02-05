SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spBatchGetOperationsQuery]
    @startId INT,
    @endId INT
AS
BEGIN
    ;WITH audit_ids AS
    (
        SELECT
            s.AuditId
        FROM administration.dbo.TSystemAudit s
        WHERE s.AuditId > @startId
            AND s.AuditId <= @endId
    )
    ,audit_records AS
    (
        SELECT TOP 1 WITH TIES
            s.AuditId,
            s.StampAction,
            s.SystemId
        FROM audit_ids ids
        INNER JOIN administration.dbo.TSystemAudit s ON s.AuditId = ids.AuditId
        ORDER BY ROW_NUMBER() OVER (PARTITION BY s.SystemId ORDER BY s.AuditId DESC)
    )
    SELECT
        audit.AuditId,
        audit.SystemId AS OperationId,
        s.ParentId,
        ISNULL(s.SystemPath, '') AS SystemPath,
        IIF(s.SystemPath IS NULL OR audit.StampAction = 'D', 1,0) AS IsForDelete
    FROM audit_records audit
    LEFT JOIN administration.dbo.TSystem s ON s.SystemId = audit.SystemId
END
GO