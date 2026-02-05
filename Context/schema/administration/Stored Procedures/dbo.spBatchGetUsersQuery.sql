SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spBatchGetUsersQuery]
    @startId INT,
    @endId INT,
    @batchSize INT
AS
BEGIN
    ;WITH audit_ids AS
    (
        SELECT TOP (@batchSize)
            u.AuditId
        FROM administration.dbo.TUserAudit u
        WHERE u.AuditId > @startId
            AND u.AuditId <= @endId
    )
    ,audit_records AS
    (
        SELECT TOP 1 WITH TIES
            a.AuditId,
            a.StampAction,
            a.UserId
        FROM audit_ids ids
        INNER JOIN administration.dbo.TUserAudit a ON a.AuditId = ids.AuditId
        ORDER BY ROW_NUMBER() OVER (PARTITION BY a.UserId ORDER BY a.AuditId DESC)
    )
    SELECT
        audit.AuditId,
        audit.UserId,
        u.SuperUser,
        u.SuperViewer,
        u.ActiveRole,
        r.RefLicenseTypeId AS LicenseId,
        IIF(u.ActiveRole IS NULL OR r.RefLicenseTypeId IS NULL OR audit.StampAction = 'D', 1,0) AS IsForDelete
    FROM audit_records audit
    LEFT JOIN administration.dbo.TUser u ON u.UserId = audit.UserId AND u.RefUserTypeId != 4 -- IS NOT EQUAL PfpUser
    LEFT JOIN administration.dbo.TRole r ON u.ActiveRole = r.RoleId
END
GO