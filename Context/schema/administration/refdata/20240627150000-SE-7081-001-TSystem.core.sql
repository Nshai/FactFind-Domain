USE Administration

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @StampDateTime DATETIME
      , @StampActionCreate CHAR(1)
      , @StampUser INT
      , @programSystemPath varchar(max)

--Use the line below to generate a GUID.
--Please DO NOT make it part of the script. You should only generate the GUID once.
--SELECT NEWID()

SELECT @ScriptGUID = '21AD5A47-8C6E-475D-AC06-74DA97EB4F76'
      , @Comments = 'SE-7081 TSystem Add Security Key for Download Template - Add Fee Related Client Or Plan'
      , @StampDateTime = GETUTCDATE()
      , @StampActionCreate = 'C'
      , @StampUser = 0
      , @programSystemPath = 'home.uploads.datauploader.importaddfeerelatedclientorplan'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

BEGIN TRANSACTION
    
    BEGIN TRY
        DECLARE  @ParentSystemId int

        SET @ParentSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = 'home.uploads.datauploader')

        IF NOT EXISTS (SELECT 1 FROM [dbo].TSystem WHERE SystemPath = @programSystemPath)
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
				 VALUES('importaddfeerelatedclientorplan', 'Add Fee (Client or Product related)', @programSystemPath, '-action', @ParentSystemId,  NULL, NULL, 1)
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