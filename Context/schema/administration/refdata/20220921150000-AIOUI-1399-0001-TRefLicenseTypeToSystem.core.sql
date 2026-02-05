USE [administration]

DECLARE
    @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255)

/*

Summary
----------------------------------------------------------------------
Removing permissions for all license types for Transfer Documents tab.


DatabaseName    TableName               Expected Rows
-----------------------------------------------------
administration  TRefLicenseTypeToSystem 2

*/

SELECT
    @ScriptGUID = '09502F3D-9978-4234-9782-081BA9A6463A',
    @Comments = 'AIOUI-1399 Remove Transfer Documents tab'

IF EXISTS (SELECT 1 FROM [TExecutedDataScript] WHERE [ScriptGUID] = @ScriptGUID)
    RETURN

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
    BEGIN TRANSACTION

    DECLARE
        @TransferDocumentsSystemPath VARCHAR(256) = 'adviserworkplace.clients.plans.transferdocuments',
        @TransferDocumentsFullListSystemPath VARCHAR(256) = 'adviserworkplace.clients.plans.transferdocumentsfulllist'

    DELETE [TRefLicenseTypeToSystem]
    OUTPUT
        deleted.[RefLicenseTypeToSystemId],
        deleted.[RefLicenseTypeId],
        deleted.[SystemId],
        deleted.[ConcurrencyId],
        'D',
        GETUTCDATE(),
        0
    INTO
        [TRefLicenseTypeToSystemAudit](
            [RefLicenseTypeToSystemId],
            [RefLicenseTypeId],
            [SystemId],
            [ConcurrencyId],
            [StampAction],
            [StampDateTime],
            [StampUser]
        )
    FROM [TRefLicenseTypeToSystem] r
    JOIN [TSystem] s ON s.[SystemId] = r.[SystemId]
    WHERE s.[SystemPath] = @TransferDocumentsSystemPath OR s.[SystemPath] = @TransferDocumentsFullListSystemPath

    INSERT [TExecutedDataScript] ([ScriptGUID], [Comments]) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        THROW
END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN
