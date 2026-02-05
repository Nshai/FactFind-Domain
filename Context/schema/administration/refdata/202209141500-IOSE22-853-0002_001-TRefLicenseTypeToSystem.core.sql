USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = '1B27B74F-79B5-4F13-ABB8-E5FDBBE0F338'
      , @Comments = 'IOSE22-853 Live chat security. Add permissions to the full type license'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
RETURN; 

BEGIN TRANSACTION

        BEGIN TRY

        DECLARE @StampAction char(1) = 'C',
        @StampDateTime datetime = GETUTCDATE(),
        @StampUser int = 0,
        @LiveChatSystemId int,
        @RefLicenseTypeIdFull int,
        @LiveChatSystemPath varchar(max) = 'toplevelnavigation.livechat'

        SELECT @LiveChatSystemId = SystemID
        FROM TSystem
        WHERE SystemPath = @LiveChatSystemPath

        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @LiveChatSystemId)
        BEGIN
            INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                            ([RefLicenseTypeId]
                            ,[SystemId]
                            ,[ConcurrencyId])
            OUTPUT inserted.[RefLicenseTypeId]
                ,inserted.[SystemId]
                ,inserted.[ConcurrencyId]
                ,inserted.[RefLicenseTypeToSystemId]
                ,@StampAction
                ,@StampDateTime
                ,@StampUser
            INTO [dbo].[TRefLicenseTypeToSystemAudit]
                ([RefLicenseTypeId]
                ,[SystemId]
                ,[ConcurrencyId]
                ,[RefLicenseTypeToSystemId]
                ,[StampAction]
                ,[StampDateTime]
                ,[StampUser])
            SELECT RefLicenseTypeId,
                    @LiveChatSystemId,
                    1
            FROM TRefLicenseType WHERE LicenseTypeName IN ('full', 'mortgage', 'mortgageadmin')
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