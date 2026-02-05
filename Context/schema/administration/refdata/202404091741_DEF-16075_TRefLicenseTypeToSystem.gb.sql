USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @PortfolioReportingSystemId INT
      , @PortfolioReportingApplicationsSystemId INT
      , @StampDateTime DATETIME = GETUTCDATE()
      , @StampAction CHAR(1) = 'D'
      , @StampUser INT = 0
      , @ConcurrencyId INT = 1

SELECT @ScriptGUID = '36BC37B6-3119-4DC0-B6E6-629613149C77'
      ,@Comments = 'DEF-16075 Revert of PA-17891 [data-fix] Grant ability to set Application report page for all license types'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-- Expected row counts:
-- (20 row(s) affected)

SET @PortfolioReportingSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = 'portfolioreporting')
SET @PortfolioReportingApplicationsSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = 'portfolioreporting.applications')

BEGIN TRANSACTION

    BEGIN TRY

        -- Delete Applications subnode to all license types that have Portfolio node
        BEGIN
            DELETE FROM [dbo].[TRefLicenseTypeToSystem]
            OUTPUT
                 deleted.[RefLicenseTypeId]
                ,deleted.[SystemId]
                ,deleted.[ConcurrencyId]
                ,deleted.[RefLicenseTypeToSystemId]
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
            WHERE SystemId = @PortfolioReportingApplicationsSystemId
        END

        -- Delete Portfolio node to all license types
        BEGIN
            DELETE FROM [dbo].[TRefLicenseTypeToSystem]
            OUTPUT
                 deleted.[RefLicenseTypeId]
                ,deleted.[SystemId]
                ,deleted.[ConcurrencyId]
                ,deleted.[RefLicenseTypeToSystemId]
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
            WHERE SystemId = @PortfolioReportingSystemId
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
