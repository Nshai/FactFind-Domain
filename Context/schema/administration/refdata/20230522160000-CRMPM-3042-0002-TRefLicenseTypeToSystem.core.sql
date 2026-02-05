USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @MiReportsSystemId INT
      , @DashboardsSystemId INT
      , @DataExportSystemId INT
      , @StampDateTime DATETIME = GETUTCDATE()
      , @StampAction CHAR(1) = 'C'
      , @StampUser INT = 0
      , @ConcurrencyId INT = 1

SELECT @ScriptGUID = '964DB900-5A7A-4E8D-B497-DEE25393D085'
      ,@Comments = 'CRMPM-3042 TRefLicenseTypeToSystem Add new security items by functional area for Business Intelligence UI to specified license types'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-- Expected row counts:
-- (10 row(s) affected)

SET @MiReportsSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = 'mi')
SET @DashboardsSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = 'mi.dashboards')
SET @DataExportSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = 'mi.dataexport')

BEGIN TRANSACTION

    BEGIN TRY

        -- Add Dashboards node to license types
        IF NOT EXISTS (SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @DashboardsSystemId)
        BEGIN
            INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                ([RefLicenseTypeId]
                ,[SystemId]
                ,[ConcurrencyId])
            OUTPUT
                 INSERTED.[RefLicenseTypeId]
                ,INSERTED.[SystemId]
                ,INSERTED.[ConcurrencyId]
                ,INSERTED.[RefLicenseTypeToSystemId]
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
            SELECT
                 [RefLicenseTypeId]
                ,@DashboardsSystemId
                ,@ConcurrencyId
            FROM [dbo].[TRefLicenseTypeToSystem]
            WHERE SystemId = @MiReportsSystemId
        END

        -- Add Data Export node to license types
        IF NOT EXISTS (SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @DataExportSystemId)
        BEGIN
            INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                ([RefLicenseTypeId]
                ,[SystemId]
                ,[ConcurrencyId])
            OUTPUT
                 INSERTED.[RefLicenseTypeId]
                ,INSERTED.[SystemId]
                ,INSERTED.[ConcurrencyId]
                ,INSERTED.[RefLicenseTypeToSystemId]
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
            SELECT
                 [RefLicenseTypeId]
                ,@DataExportSystemId
                ,@ConcurrencyId
            FROM [dbo].[TRefLicenseTypeToSystem]
            WHERE SystemId = @MiReportsSystemId
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

-- Check for ANY open transactions
-- This applies not only to THIS script but will rollback any open transactions in any scripts that have been run before this one.
IF @@TRANCOUNT > 0
BEGIN
       ROLLBACK
       RETURN
       PRINT 'Open transaction found, aborting'
END

RETURN;