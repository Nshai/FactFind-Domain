USE administration;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = '8EC5F1A8-4F73-410E-A323-0E9D5BD68F05',
    @Comments = 'AIOCRM-414 Add permissions to the full type license for US'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary:
--   Add new system pathes within adviserworkplace.client.details

-- Expected row counts: 6 row(s) affected
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT,
        @StampDateTime datetime = GETUTCDATE(),
        @StampUser INT = 0,
        @StampActionCreate CHAR= 'C'

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

    ------ Add TRefLicenseTypeToSystem------

    DECLARE @systemType NVARCHAR(15) = '-view',
        @proofOfIdentitySystemPath NVARCHAR(100) = 'adviserworkplace.clients.details.proofofidentity',
        @employmentSystemPath NVARCHAR(100) = 'adviserworkplace.clients.details.employment',
        @financeAndTaxSystemPath NVARCHAR(100) = 'adviserworkplace.clients.details.financeandtax',
        @proofOfIdentitySystemId INT,
        @employmentSystemId INT,
        @financeAndTaxSystemId INT;

    -- Proofidentity
    SET @proofOfIdentitySystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @proofOfIdentitySystemPath and SystemType = @systemType)

    IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @proofOfIdentitySystemId)
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
            @proofOfIdentitySystemId,
            1
        FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
    END

    -- Employment
    SET @employmentSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @employmentSystemPath and SystemType = @systemType)

    IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @employmentSystemId)
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
            @employmentSystemId,
            1
        FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
    END

    -- Finance and tax
    SET @financeAndTaxSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @financeAndTaxSystemPath and SystemType = @systemType)

    IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @financeAndTaxSystemId)
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
            @financeAndTaxSystemId,
            1
        FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
    END

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    IF @starttrancount = 0
        COMMIT TRANSACTION

END TRY
BEGIN CATCH

        DECLARE @ErrorSeverity INT
        DECLARE @ErrorState INT
        DECLARE @ErrorLine INT
        DECLARE @ErrorNumber INT

        SELECT @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorLine = ERROR_LINE()

        /*Insert into logging table - IF ANY    */

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
