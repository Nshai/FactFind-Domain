USE Administration

DECLARE @ScriptGUID uniqueidentifier,
    @Comment varchar(255),
    @ErrorMessage varchar(max), 
    @StampDateTime DATETIME,
    @StampActionCreate CHAR(1),
    @StampUser INT,
    @PeriodicOrdersSystemPath varchar(max),
    @SystemType varchar(max),
    @ParentSystemPath varchar(max),
    @ParentId INT


SELECT
    @ScriptGUID = '3D39499E-AF8A-4987-A668-BD72F908AEEC',
    @Comment = 'AIOUI-2254 - Create RefLicenseType with full license for periodic orders',
    @StampDateTime = GETUTCDATE(),
    @StampActionCreate = 'C',
    @StampUser = 0,
    @PeriodicOrdersSystemPath = 'adviserworkplace.clients.plans.periodicorders',
    @SystemType = '-view',
    @ParentSystemPath = 'adviserworkplace.clients.plans'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add security key for periodec orders

-- Expected row counts:
-- TSystem (1 row affected)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

        IF EXISTS (SELECT 1 FROM [dbo].[TSystem] WHERE SystemPath = @PeriodicOrdersSystemPath)
            RETURN

        SELECT @ParentId = [SystemId]
        FROM [dbo].[TSystem]
        WHERE SystemPath = @ParentSystemPath

        INSERT INTO [dbo].[TSystem]([Identifier], [Description], [SystemPath], [SystemType], [ParentId])
            OUTPUT inserted.[SystemId]
                , inserted.[Identifier]
                , inserted.[Description]
                , inserted.[SystemPath]
                , inserted.[SystemType]
                , inserted.[ParentId]
                , inserted.[ConcurrencyId]
                , @StampActionCreate
                , @StampDateTime
                , @StampUser
            INTO [dbo].[TSystemAudit]([SystemId], [Identifier], [Description], [SystemPath], [SystemType], [ParentId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
            VALUES
                ('periodicorders'
                , 'Periodic Orders'
                , @PeriodicOrdersSystemPath
                , @SystemType
                , @ParentId)

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