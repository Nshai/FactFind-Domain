USE [administration]

DECLARE
    @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255)

/*

Summary
----------------------------------------------------------------------
Removing permissions for all license types for LiveChat.


DatabaseName    TableName   Expected Rows
-----------------------------------------
administration  TSystem     1

*/

SELECT
    @ScriptGUID = 'EA9F2F3B-EC0F-4F30-8D61-C51871F82412',
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
        @stampAction,
        @stampDateTime,
        @stampUser
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
    WHERE [SystemPath] = @LiveChatSystemPath

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