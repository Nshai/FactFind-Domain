USE Administration

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @StampDateTime DATETIME
      , @StampActionCreate CHAR(1)
      , @StampUser INT
      , @OpenApplicationSystemPath varchar(max)

--Use the line below to generate a GUID.
--Please DO NOT make it part of the script. You should only generate the GUID once.
--SELECT NEWID()

SELECT @ScriptGUID = '60AB30D8-1E57-4904-82B3-AC360125C0D3'
      , @Comments = 'PA-11823 For UK: Add Admin Security settings: By Functional Area > Systems > Adviser Workplace > Clients > Open Application. TSystem.'
      , @StampDateTime = GETUTCDATE()
      , @StampActionCreate = 'C'
      , @StampUser = 0
      , @OpenApplicationSystemPath = 'adviserworkplace.clients.plans.openapplication'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

BEGIN TRANSACTION
    
    BEGIN TRY
        DECLARE  @ParentSystemId int

        SET @ParentSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = 'adviserworkplace.clients.plans')

        IF NOT EXISTS (SELECT 1 FROM [dbo].TSystem WHERE SystemPath = @OpenApplicationSystemPath)
            BEGIN
                INSERT INTO [dbo].TSystem ([Identifier], [Description], [SystemPath], [SystemType], [ParentId], [Url], [EntityId], [ConcurrencyId])
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
                    @StampActionCreate,
                    @StampDateTime,
                    @StampUser
                INTO [dbo].TSystemAudit
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
                VALUES ('openapplication', 'Open Application', @OpenApplicationSystemPath, '-action', @ParentSystemId, NULL, NULL, 1)
            END

        -- END DATA INSERT/UPDATE
    END TRY
    BEGIN CATCH
    
        SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
        WHILE(@@TRANCOUNT > 0)ROLLBACK
        RETURN
    
    END CATCH

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)
    
COMMIT TRANSACTION

-- Check for ANY open transactions
-- This applies not only to THIS script but will rollback any open transactions in any scripts that have been run before this one.
IF @@TRANCOUNT > 0
BEGIN
       ROLLBACK
       RETURN
       PRINT 'Open transaction found, aborting'
END

RETURN;