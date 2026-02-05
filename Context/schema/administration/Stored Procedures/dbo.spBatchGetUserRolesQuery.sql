SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spBatchGetUserRolesQuery]
    @startId INT,
    @endId INT,
    @batchSize INT
AS
BEGIN
    ;WITH audit_ids AS
    (
        SELECT TOP(@batchSize)
            m.AuditId
        FROM administration.dbo.TMembershipAudit m
        WHERE m.AuditId > @startId
            AND m.AuditId <= @endId
    )
    ,audit_records AS
    (
        SELECT TOP 1 WITH TIES
            m.AuditId,
            m.StampAction,
            m.UserId,
            m.RoleId
        FROM audit_ids ids
        INNER JOIN administration.dbo.TMembershipAudit m ON m.AuditId = ids.AuditId
        ORDER BY ROW_NUMBER() OVER (PARTITION BY m.UserId, m.RoleId ORDER BY m.AuditId DESC)
    )
    SELECT
        audit.AuditId,
        audit.UserId,
        audit.RoleId,
        IIF(m.MembershipId IS NULL OR audit.StampAction = 'D', 1,0) AS IsForDelete
    FROM audit_records audit
    LEFT JOIN administration.dbo.TMembership m ON m.UserId = audit.UserId AND m.RoleId = audit.RoleId
END
GO