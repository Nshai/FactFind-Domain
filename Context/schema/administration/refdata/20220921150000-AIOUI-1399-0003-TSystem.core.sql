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
administration  TSystem     2

*/

SELECT
    @ScriptGUID = 'D8EC2BB7-C65E-485F-8592-F94B1AEBBFD3',
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

    DELETE [TSystem]
    OUTPUT
        deleted.[SystemId],
        deleted.[Identifier],
        deleted.[Description],
        deleted.[SystemPath],
        deleted.[SystemType],
        deleted.[ParentId],
        deleted.[Url],
        deleted.[EntityId],
        deleted.[ConcurrencyId],
        deleted.[Order],
        'D',
        GETUTCDATE(),
        0
    INTO
        TSystemAudit(
            [SystemId],
            [Identifier],
            [Description],
            [SystemPath],
            [SystemType],
            [ParentId],
            [Url],
            [EntityId],
            [ConcurrencyId],
            [Order],
            [StampAction],
            [StampDateTime],
            [StampUser]
        )
    FROM [TSystem]
    WHERE [SystemPath] = @TransferDocumentsSystemPath OR [SystemPath] = @TransferDocumentsFullListSystemPath

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
