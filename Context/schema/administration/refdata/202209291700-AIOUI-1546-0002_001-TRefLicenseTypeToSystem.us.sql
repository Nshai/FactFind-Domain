USE Administration


DECLARE @ScriptGUID uniqueidentifier,
        @Comments varchar(255),
        @ErrorMessage varchar(max), 
        @StampDateTime DATETIME,
        @StampActionCreate CHAR(1),
        @StampUser INT

SELECT
  @ScriptGUID = 'A882CEBC-BE3C-43DE-A915-4A1E67A058A4',
  @Comments = 'AIOUI-1546 - Create RefLicenseType with full license viewing Orderbook restricted data',
  @StampDateTime = GETUTCDATE(),
  @StampActionCreate = 'C',
  @StampUser = 0

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add security key to manage access to restrincted Orderbook data

-- Expected row counts:
-- TRefLicenseTypeToSystem (2 row(s) affected)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT

BEGIN TRY
  SELECT
    @starttrancount = @@TRANCOUNT

  IF @starttrancount = 0
    BEGIN TRANSACTION

    DECLARE
      @CanViewRestrictedDataSystemId INT,
      @CanViewRestrictedDataSystemPath NVARCHAR(70) = 'portfolioreporting.trading.orderbook.canviewrestricteddata',
      @CanViewRestrictedDataSystemType NVARCHAR(70) = '-action'

    ------ Add TRefLicenseTypeToSystem ------

    SET @CanViewRestrictedDataSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @CanViewRestrictedDataSystemPath AND SystemType = @CanViewRestrictedDataSystemType)

    IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @CanViewRestrictedDataSystemId)
    BEGIN
      INSERT INTO [dbo].[TRefLicenseTypeToSystem] (
        [RefLicenseTypeId]
        ,[SystemId]
        ,[ConcurrencyId]
      )
      OUTPUT inserted.[RefLicenseTypeId]
        ,inserted.[SystemId]
        ,inserted.[ConcurrencyId]
        ,inserted.[RefLicenseTypeToSystemId]
        ,@StampActionCreate
        ,@StampDateTime
        ,@StampUser
      INTO [dbo].[TRefLicenseTypeToSystemAudit] (
        [RefLicenseTypeId]
        ,[SystemId]
        ,[ConcurrencyId]
        ,[RefLicenseTypeToSystemId]
        ,[StampAction]
        ,[StampDateTime]
        ,[StampUser])
      SELECT RefLicenseTypeId,
        @CanViewRestrictedDataSystemId,
        1
      FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
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

  /*Insert into logging table - IF ANY*/

  IF XACT_STATE() <> 0
    AND @starttrancount = 0
    ROLLBACK TRANSACTION

  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN; 