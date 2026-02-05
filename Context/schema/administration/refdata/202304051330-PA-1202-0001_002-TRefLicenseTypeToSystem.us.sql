USE Administration


DECLARE @ScriptGUID uniqueidentifier,
      @Comments varchar(255),
      @ErrorMessage varchar(max), 
      @StampDateTime DATETIME,
      @StampActionCreate CHAR(1),
      @StampUser INT,
      @ModelPortfolioSystemPath varchar(max),
      @ModelPortfolioSystemId INT,
      @PublishedModelsSystemPath varchar(max),
      @PublishedModelsSystemId INT,
      @DraftModelsSystemPath varchar(max),
      @DraftModelsSystemId INT,
      @FullLicenseTypeId INT

SELECT @ScriptGUID = '448EC23B-2A30-4566-A1D6-3AF18849FC22'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SELECT
  @Comments = 'PA-1202 - Add RefLicenseType with full license for portfolio model tree',
  @StampDateTime = GETUTCDATE(),
  @StampActionCreate = 'C',
  @StampUser = 0,
  @ModelPortfolioSystemPath = 'portfolioreporting.modelportfolio',
  @PublishedModelsSystemPath = 'portfolioreporting.modelportfolio.publishedmodels',
  @DraftModelsSystemPath = 'portfolioreporting.modelportfolio.draftmodels'

-----------------------------------------------------------------------------------------------
-- Summary: Add RefLicenseType with full license for portfolio model tree

-- Expected row counts:
-- TRefLicenseTypeToSystem (3 row(s) affected)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
  SELECT
      @starttrancount = @@TRANCOUNT

  IF @starttrancount = 0
      BEGIN TRANSACTION

      SELECT @ModelPortfolioSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @ModelPortfolioSystemPath)
      SELECT @PublishedModelsSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @PublishedModelsSystemPath)
      SELECT @DraftModelsSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @DraftModelsSystemPath)
      SELECT @FullLicenseTypeId = (SELECT TOP 1 RefLicenseTypeId FROM TRefLicenseType WHERE LicenseTypeName IN ('full'))

      -- Model Portfolio
      IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @ModelPortfolioSystemId AND RefLicenseTypeId = @FullLicenseTypeId)
  BEGIN
      INSERT INTO [dbo].[TRefLicenseTypeToSystem]([RefLicenseTypeId], [SystemId], [ConcurrencyId])
        OUTPUT inserted.[RefLicenseTypeToSystemId]
            , inserted.[RefLicenseTypeId]
            , inserted.[SystemId]
            , inserted.[ConcurrencyId]
            , @StampActionCreate
            , @StampDateTime
            , @StampUser
        INTO [dbo].[TRefLicenseTypeToSystemAudit]([RefLicenseTypeToSystemId], [RefLicenseTypeId], [SystemId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
        VALUES (@FullLicenseTypeId, @ModelPortfolioSystemId, 1)
  END

      -- Draft Models
      IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @DraftModelsSystemId AND RefLicenseTypeId = @FullLicenseTypeId)
  BEGIN
      INSERT INTO [dbo].[TRefLicenseTypeToSystem]([RefLicenseTypeId], [SystemId], [ConcurrencyId])
        OUTPUT inserted.[RefLicenseTypeToSystemId]
            , inserted.[RefLicenseTypeId]
            , inserted.[SystemId]
            , inserted.[ConcurrencyId]
            , @StampActionCreate
            , @StampDateTime
            , @StampUser
        INTO [dbo].[TRefLicenseTypeToSystemAudit]([RefLicenseTypeToSystemId], [RefLicenseTypeId], [SystemId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
        VALUES (@FullLicenseTypeId, @DraftModelsSystemId, 1)
  END

        -- Published Models
      IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @PublishedModelsSystemId AND RefLicenseTypeId = @FullLicenseTypeId)
  BEGIN
      INSERT INTO [dbo].[TRefLicenseTypeToSystem]([RefLicenseTypeId], [SystemId], [ConcurrencyId])
        OUTPUT inserted.[RefLicenseTypeToSystemId]
            , inserted.[RefLicenseTypeId]
            , inserted.[SystemId]
            , inserted.[ConcurrencyId]
            , @StampActionCreate
            , @StampDateTime
            , @StampUser
        INTO [dbo].[TRefLicenseTypeToSystemAudit]([RefLicenseTypeToSystemId], [RefLicenseTypeId], [SystemId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
        VALUES (@FullLicenseTypeId, @PublishedModelsSystemId, 1)
  END


INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

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