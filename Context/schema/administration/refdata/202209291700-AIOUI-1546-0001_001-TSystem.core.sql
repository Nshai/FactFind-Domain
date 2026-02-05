USE Administration


DECLARE @ScriptGUID uniqueidentifier,
        @Comments varchar(255),
        @ErrorMessage varchar(max),
        @StampDateTime DATETIME,
        @StampActionCreate CHAR(1),
        @StampUser INT

SELECT
  @ScriptGUID = '4E0E654A-2380-45CF-89F7-60CC81A25A26',
  @Comments = 'AIOUI-1546 - Added permission for viewing Orderbook restricted data',
  @StampDateTime = GETUTCDATE(),
  @StampActionCreate = 'C',
  @StampUser = 0

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
  RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add permission for viewing Orderbook restricted data

-- Expected row counts:
-- TSystem (2 row(s) affected)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
  SELECT
    @starttrancount = @@TRANCOUNT

  IF @starttrancount = 0
  BEGIN TRANSACTION

    ------ Add permission ------
    DECLARE
      @TradingOrderbookParentSystemId INT,
      @CanViewRestrictedDataSystemPath NVARCHAR(70) = 'portfolioreporting.trading.orderbook.canviewrestricteddata',
      @CanViewRestrictedDataSystemType NVARCHAR(70) = '-action'

    SELECT @TradingOrderbookParentSystemId = SystemID
    FROM TSystem
    WHERE SystemPath = 'portfolioreporting.trading.orderbook' AND SystemType = '-function'

    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @CanViewRestrictedDataSystemPath AND SystemType = @CanViewRestrictedDataSystemType)
    BEGIN

      INSERT INTO TSystem ([Identifier], [Description], [SystemPath], [SystemType], [ParentId], [Url], [EntityId], [ConcurrencyId])
      OUTPUT
        INSERTED.[SystemId],
        INSERTED.[Identifier],
        INSERTED.[Description],
        INSERTED.[SystemPath],
        INSERTED.[SystemType],
        INSERTED.[ParentId],
        INSERTED.[Url],
        INSERTED.[EntityId],
        INSERTED.[ConcurrencyId],
        @StampActionCreate,
        @StampDateTime,
        @StampUser
      INTO TSystemAudit
      (
        [SystemId],
        [Identifier],
        [Description],
        [SystemPath],
        [SystemType],
        [ParentId],
        [Url],
        [EntityId],
        [ConcurrencyId],
        [StampAction],
        [StampDateTime],
        [StampUser]
      )
      VALUES ('canviewrestricteddata', 'Can View Restricted Data', @CanViewRestrictedDataSystemPath, @CanViewRestrictedDataSystemType, @TradingOrderbookParentSystemId, NULL, NULL, 1)
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