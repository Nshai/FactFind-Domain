USE Administration

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @StampDateTime DATETIME
      , @StampActionCreate CHAR(1)
      , @StampUser INT
      , @OpenApplicationSystemPath varchar(max)
      , @SubmitApplicationSystemPath varchar(max)

--Use the line below to generate a GUID.
--Please DO NOT make it part of the script. You should only generate the GUID once.
--SELECT NEWID()

SELECT @ScriptGUID = '7B68D5F7-993A-4271-8FA8-DDD58754288D'
      , @Comments = 'PA-11823 For UK: Add Admin Security settings: By Functional Area > Systems > Adviser Workplace > Clients > Open Application. TRefLicenseType.'
      , @StampDateTime = GETUTCDATE()
      , @StampActionCreate = 'C'
      , @StampUser = 0
      , @OpenApplicationSystemPath = 'adviserworkplace.clients.plans.openapplication'
       ,@SubmitApplicationSystemPath = 'plan.actions.submitapplication'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

BEGIN TRANSACTION
    
    BEGIN TRY
		DECLARE 
			@OpenApplicationSystemId int,
			@SubmitApplicationSystemId int

        SELECT @OpenApplicationSystemId = SystemID
        FROM [dbo].TSystem
        WHERE SystemPath = @OpenApplicationSystemPath

        SELECT @SubmitApplicationSystemId = SystemID
        FROM [dbo].TSystem
        WHERE SystemPath = @SubmitApplicationSystemPath

        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @OpenApplicationSystemId)
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
                SELECT lic.RefLicenseTypeId, @OpenApplicationSystemId, 1
                FROM [dbo].TRefLicenseType  lic
                INNER JOIN [dbo].[TRefLicenseTypeToSystem] refLic
                ON lic.RefLicenseTypeId = refLic.RefLicenseTypeId
                WHERE refLic.SystemId = @SubmitApplicationSystemId
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