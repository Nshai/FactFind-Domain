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

SELECT @ScriptGUID = 'CB4547BA-DD92-4324-8909-E2C5542FFF2E'
      , @Comments = 'PA-15840 For all envs: Add Admin Security settings: By Functional Area > Administration > Organisation > Program. TRefLicenseType.'
      , @StampDateTime = GETUTCDATE()
      , @StampActionCreate = 'C'
      , @StampUser = 0
      , @programSystemPath = 'administration.organisation.program'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

BEGIN TRANSACTION
    
    BEGIN TRY
		DECLARE 
			@programSystemId int,
			@LicenseTypeId int

		SELECT @LicenseTypeId = RefLicenseTypeId
		FROM [dbo].TRefLicenseType
		WHERE LicenseTypeName = 'Full'

        SELECT @programSystemId = SystemID
        FROM [dbo].TSystem
        WHERE SystemPath = @programSystemPath


        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @programSystemId)
            BEGIN
                INSERT INTO [dbo].[TRefLicenseTypeToSystem] ([RefLicenseTypeId], [SystemId], [ConcurrencyId])
                OUTPUT 
                    INSERTED.[RefLicenseTypeId],
                    INSERTED.[SystemId],
                    INSERTED.[ConcurrencyId],
                    INSERTED.[RefLicenseTypeToSystemId],
                    @StampActionCreate,
                    @StampDateTime,
                    @StampUser
                INTO [dbo].[TRefLicenseTypeToSystemAudit]
                (
                    [RefLicenseTypeId],
                    [SystemId],
                    [ConcurrencyId],
                    [RefLicenseTypeToSystemId],
                    [StampAction],
                    [StampDateTime],
                    [StampUser]
                )
                VALUES (@LicenseTypeId, @programSystemId, 1)
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