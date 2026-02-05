USE Administration


DECLARE @ScriptGUID uniqueidentifier,
        @Comments varchar(255),
        @ErrorMessage varchar(max), 
        @StampDateTime DATETIME,
        @StampActionCreate CHAR(1),
        @StampUser INT,
        @AccountPerformanceSystemPath varchar(max),
        @AccountPerformanceFullListSystemPath varchar(max),
        @TenantId INT

--Use the line below to generate a GUID.
--Please DO NOT make it part of the script. You should only generate the GUID once.
--SELECT NEWID()

SELECT
    @ScriptGUID = '76920F51-2FF6-4486-806A-590C44308B8B',
    @Comments = 'PA-5988 - Create Account Performance Full List Entitlements',
    @StampDateTime = GETUTCDATE(),
    @StampActionCreate = 'C',
    @StampUser = 0,
    @AccountPerformanceSystemPath = 'adviserworkplace.clients.plans.accountperformance',
    @AccountPerformanceFullListSystemPath = 'adviserworkplace.clients.plans.accountperformancefulllist'

/*
    NOTE: By default the scripts will run on ALL environments as part of a data refresh
    If this script needs to be run on a specific environment, change and enable this. 
*/

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add security key to manage access to Householding

-- Expected row counts:
--TRefLicenseTypeToSystem (2 row(s) affected)
--TRefLicenseTypeToSystemAudit (2 row(s) affected)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT
        @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

        DECLARE
            @ClientActionSystemId int,
            @AccountPerformanceSystemId int,
            @AccountPerformanceFullListSystemId int

        SET @ClientActionSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = 'adviserworkplace.clients.plans')
        SET @AccountPerformanceSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @AccountPerformanceSystemPath and SystemType = '-view')
        SET @AccountPerformanceFullListSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @AccountPerformanceFullListSystemPath and SystemType = '-view')

        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @AccountPerformanceSystemId)
        BEGIN
            INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                        ([RefLicenseTypeId]
                        ,[SystemId]
                        ,[ConcurrencyId])
                OUTPUT inserted.[RefLicenseTypeId]
                        ,inserted.[SystemId]
                        ,inserted.[ConcurrencyId]
                        ,inserted.[RefLicenseTypeToSystemId]
                        ,@StampActionCreate
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
                       @AccountPerformanceSystemId,
                       1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
        END

        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @AccountPerformanceFullListSystemId)
        BEGIN
            INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                        ([RefLicenseTypeId]
                        ,[SystemId]
                        ,[ConcurrencyId])
                OUTPUT inserted.[RefLicenseTypeId]
                        ,inserted.[SystemId]
                        ,inserted.[ConcurrencyId]
                        ,inserted.[RefLicenseTypeToSystemId]
                        ,@StampActionCreate
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
                       @AccountPerformanceFullListSystemId,
                       1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
        END

IF @starttrancount = 0
	COMMIT TRANSACTION
END TRY
BEGIN CATCH

    DECLARE @ErrorSeverity int
    DECLARE @ErrorState int
    DECLARE @ErrorLine int
    DECLARE @ErrorNumber int

    SELECT
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorLine = ERROR_LINE()

    /*Insert into logging table - IF ANY    */

    IF XACT_STATE() <> 0
        AND @starttrancount = 0
        ROLLBACK TRANSACTION

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;