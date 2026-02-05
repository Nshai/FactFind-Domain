SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spBatchGetRoleOperationsQuery]
    @startId INT,
    @endId INT,
    @batchSize INT
AS
BEGIN
    ;WITH audit_ids AS
    (
        SELECT TOP(@batchSize)
            k.AuditId
        FROM administration.dbo.TKeyAudit k
        WHERE k.AuditId > @startId
            AND k.AuditId <= @endId
    )
    ,audit_records AS
    (
        SELECT TOP 1 WITH TIES
            k.AuditId,
            k.StampAction,
            k.RoleId,
            k.SystemId
        FROM audit_ids ids
        INNER JOIN administration.dbo.TKeyAudit k ON k.AuditId = ids.AuditId
        WHERE k.UserId IS NULL AND k.RoleId IS NOT NULL
        ORDER BY ROW_NUMBER() OVER (PARTITION BY k.RoleId, k.SystemId ORDER BY k.AuditId DESC)
    )
    SELECT
        audit.AuditId,
        audit.RoleId,
        audit.SystemId AS OperationId,
        IIF(ISNULL (k.RightMask, 0) = 0 OR audit.StampAction = 'D', 1, 0) IsForDelete
    FROM audit_records audit
    LEFT JOIN administration.dbo.TKey k ON k.RoleId = audit.RoleId AND k.SystemId = audit.SystemId AND k.UserId IS NULL
END
GO