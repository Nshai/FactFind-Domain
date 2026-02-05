SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spBatchGetLicenseOperationsQuery]
    @startId INT,
    @endId INT
AS
BEGIN
    ;WITH audit_ids AS
    (
        SELECT
            lt2s.AuditId
        FROM administration.dbo.TRefLicenseTypeToSystemAudit lt2s
        WHERE lt2s.AuditId > @startId
            AND lt2s.AuditId <= @endId
    )
    ,audit_records AS
    (
        SELECT TOP 1 WITH TIES
            lt2s.AuditId,
            lt2s.StampAction,
            lt2s.RefLicenseTypeId,
            lt2s.SystemId
        FROM audit_ids ids
        INNER JOIN administration.dbo.TRefLicenseTypeToSystemAudit lt2s ON lt2s.AuditId = ids.AuditId
        INNER JOIN administration.dbo.TRefLicenseType lt ON lt2s.RefLicenseTypeId = lt.RefLicenseTypeId AND lt.RefLicenseStatusId = 1
        ORDER BY ROW_NUMBER() OVER (PARTITION BY lt2s.RefLicenseTypeId, lt2s.SystemId ORDER BY lt2s.AuditId DESC)
    )
    SELECT
        audit.AuditId,
        audit.SystemId AS OperationId,
        audit.RefLicenseTypeId AS LicenseId,
        IIF(lt2s.RefLicenseTypeToSystemId IS NULL OR audit.StampAction = 'D', 1,0) AS IsForDelete
    FROM audit_records audit
    LEFT JOIN administration.dbo.TRefLicenseTypeToSystem lt2s ON lt2s.RefLicenseTypeId = audit.RefLicenseTypeId AND lt2s.SystemId = audit.SystemId
END
GO