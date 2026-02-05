USE [administration]

DECLARE
    @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255)

/*

Summary
----------------------------------------------------------------------
Removing permissions for all license types for LiveChat.


DatabaseName    TableName               Expected Rows
-----------------------------------------------------
administration  TRefLicenseTypeToSystem 3

*/

SELECT
    @ScriptGUID = '5DCBABF9-B110-4748-BFA7-DB395913C466',
    @Comments = 'IOSE22-1181 LiveChat. Remove the item from the License Config and Security Area'

IF EXISTS (SELECT 1 FROM [TExecutedDataScript] WHERE [ScriptGUID] = @ScriptGUID)
    RETURN

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
    BEGIN TRANSACTION

    DECLARE
        @LiveChatSystemPath VARCHAR(256) = 'toplevelnavigation.livechat',
		@stampDateTime DATETIME = GETUTCDATE(),
		@stampAction CHAR(1) = 'D',
		@stampUser INT = 0

    DELETE [TRefLicenseTypeToSystem]
    OUTPUT
        deleted.[RefLicenseTypeToSystemId],
        deleted.[RefLicenseTypeId],
        deleted.[SystemId],
        deleted.[ConcurrencyId],
        @stampAction,
        @stampDateTime,
        @stampUser
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
    WHERE s.[SystemPath] = @LiveChatSystemPath

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