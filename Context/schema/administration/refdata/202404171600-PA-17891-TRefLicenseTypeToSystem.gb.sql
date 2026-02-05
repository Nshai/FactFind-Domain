USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @PortfolioReportingSystemId INT
      , @PortfolioReportingApplicationsSystemId INT
      , @StampDateTime DATETIME = GETUTCDATE()
      , @StampAction CHAR(1) = 'C'
      , @StampUser INT = 0
      , @ConcurrencyId INT = 1

SELECT @ScriptGUID = '161AE50E-76F8-4D25-8457-D53662C672BD'
      ,@Comments = 'PA-19899 [CR] [data-fix] Grant ability to set Application report page for all license types (revert of revert)'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-- Expected row counts:
-- (20 row(s) affected)

SET @PortfolioReportingSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = 'portfolioreporting')
SET @PortfolioReportingApplicationsSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = 'portfolioreporting.applications')

BEGIN TRANSACTION

    BEGIN TRY

        -- Add Portfolio node to all license types
        IF NOT EXISTS (SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @PortfolioReportingSystemId)
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
                ,@PortfolioReportingSystemId
                ,@ConcurrencyId
            FROM [dbo].[TRefLicenseType]
        END

        -- Add Applications subnode to all license types that have Portfolio node
        IF NOT EXISTS (SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @PortfolioReportingApplicationsSystemId)
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
                 rlic.RefLicenseTypeId
                ,@PortfolioReportingApplicationsSystemId
                ,@ConcurrencyId
            FROM [dbo].[TRefLicenseType] rlic
            INNER JOIN [dbo].[TRefLicenseTypeToSystem] refLic
            ON rlic.RefLicenseTypeId = refLic.RefLicenseTypeId
            WHERE refLic.SystemId = @PortfolioReportingSystemId
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