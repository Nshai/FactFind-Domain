USE [administration]

DECLARE
    @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255)

/*

Summary
----------------------------------------------------------------------
Removing permissions for all license types for Transfer Documents tab.


DatabaseName    TableName   Expected Rows
-----------------------------------------
administration  TKey        2

*/

SELECT
    @ScriptGUID = '09123F8E-FD20-4AA3-8711-F4D839B0313B',
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

    DELETE [TKey]
    OUTPUT
        deleted.[KeyId],
        deleted.[RightMask],
        deleted.[SystemId],
        deleted.[UserId],
        deleted.[RoleId],
        deleted.[ConcurrencyId],
        'D',
        GETUTCDATE(),
        0
    INTO
        [TKeyAudit](
            [KeyId],
            [RightMask],
            [SystemId],
            [UserId],
            [RoleId],
            [ConcurrencyId],
            [StampAction],
            [StampDateTime],
            [StampUser]
        )
    FROM [TKey] k
    JOIN [TSystem] s ON s.[SystemId] = k.[SystemId]
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
