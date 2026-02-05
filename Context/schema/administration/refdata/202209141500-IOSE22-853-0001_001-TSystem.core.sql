USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = 'C1552B5F-7A4D-4148-9EDF-94511BE20DE5'
      , @Comments = 'IOSE22-853 Live chat security to be added to reference data table'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

BEGIN TRANSACTION

    BEGIN TRY

    DECLARE @StampAction char(1) = 'C',
        @StampDateTime datetime = GETUTCDATE(),
        @StampUser int = 0,
        @ToplevelnavigationSystemId int,
        @LiveChatSystemPath varchar(max) = 'toplevelnavigation.livechat'

        SET @ToplevelnavigationSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = 'toplevelnavigation')

        IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @LiveChatSystemPath)
            BEGIN
                INSERT INTO TSystem ([Identifier], [Description], [SystemPath], [SystemType], [ParentId], [Url], [EntityId], [ConcurrencyId])
                OUTPUT 
                    INSERTED.[SystemId],
                    INSERTED.[Identifier],
                    INSERTED.[Description],
                    INSERTED.[SystemPath],
                    INSERTED.[SystemType],
                    INSERTED.[ParentId],
                    INSERTED.[Url],
                    INSERTED.[EntityId],
                    INSERTED.[ConcurrencyId],
                    @StampAction,
                    @StampDateTime,
                    @StampUser
                INTO TSystemAudit
                (
                    [SystemId],
                    [Identifier],
                    [Description],
                    [SystemPath],
                    [SystemType],
                    [ParentId],
                    [Url],
                    [EntityId],
                    [ConcurrencyId],
                    [StampAction],
                    [StampDateTime],
                    [StampUser]
                )
                VALUES ('livechat', 'Live Chat', @LiveChatSystemPath, '-action', @ToplevelnavigationSystemId, NULL, NULL, 1)
            END

    END TRY
    BEGIN CATCH

    SET @ErrorMessage = ERROR_MESSAGE()
    RAISERROR(@ErrorMessage, 16, 1)
    WHILE(@@TRANCOUNT > 0)ROLLBACK
    RETURN

    END CATCH

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

COMMIT TRANSACTION


IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK
    RETURN
    PRINT 'Open transaction found, aborting'
END

RETURN;