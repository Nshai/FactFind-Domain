USE Administration

DECLARE @ScriptGUID uniqueidentifier,
    @Comment varchar(255),
    @ErrorMessage varchar(max),
    @StampDateTime DATETIME,
    @StampActionCreate CHAR(1),
    @StampUser INT,
    @PeriodicOrdersSystemPath varchar(max),
    @PeriodicOrdersSystemId INT,
    @FullLicenseTypeId INT

SELECT
    @ScriptGUID = '8D5008F3-A8C6-4F5B-AC19-8EE6CC488BE2',
    @Comment = 'AIOUI-1914 - Create RefLicenseType with full license for periodic orders',
    @StampDateTime = GETUTCDATE(),
    @StampActionCreate = 'C',
    @StampUser = 0,
    @PeriodicOrdersSystemPath = 'adviserworkplace.clients.plans.periodicorders'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add security key for periodec orders
-- Expected row counts:
-- TRefLicenseTypeToSystem (1 row affected)
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY

    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0

        BEGIN TRANSACTION

        SELECT @PeriodicOrdersSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @PeriodicOrdersSystemPath)
        SELECT @FullLicenseTypeId = (SELECT TOP 1 RefLicenseTypeId FROM TRefLicenseType WHERE LicenseTypeName IN ('full'))
        
        IF EXISTS (SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @PeriodicOrdersSystemId and RefLicenseTypeId = @FullLicenseTypeId)
            RETURN
        
        INSERT INTO [dbo].[TRefLicenseTypeToSystem]([RefLicenseTypeId], [SystemId], [ConcurrencyId])
        OUTPUT inserted.[RefLicenseTypeToSystemId]
            , inserted.[RefLicenseTypeId]
            , inserted.[SystemId]
            , inserted.[ConcurrencyId]
            , @StampActionCreate
            , @StampDateTime
            , @StampUser
        INTO [dbo].[TRefLicenseTypeToSystemAudit]([RefLicenseTypeToSystemId], [RefLicenseTypeId], [SystemId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
        VALUES (@FullLicenseTypeId, @PeriodicOrdersSystemId, 1)
        
        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comment)
        
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
    
    /*Insert into logging table - IF ANY  */
    IF XACT_STATE() <> 0
      AND @starttrancount = 0
      ROLLBACK TRANSACTION
  
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;