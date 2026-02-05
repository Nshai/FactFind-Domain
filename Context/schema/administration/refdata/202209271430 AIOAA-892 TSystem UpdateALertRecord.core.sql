USE administration

DECLARE @ScriptGUID uniqueidentifier,
        @Comments varchar(255),
        @ErrorMessage varchar(max), 
        @StampDateTime DATETIME,
        @StampActionUpdate CHAR(1),
        @StampUser INT,
        @OldAlertsSystemPath varchar(max),
        @OldAlertsSystemType varchar(max),
        @NewAlertsSystemPath varchar(max),
        @NewAlertsSystemType varchar(max)


SELECT
        @ScriptGUID = '3CD7BD40-E86C-4F07-B123-60429A60E257',
        @Comments = 'AIOAA-892: Move Alerts Tab from Accounts to My Setup',
        @StampDateTime = GETUTCDATE(),
        @StampActionUpdate = 'U',
        @StampUser = 0,
        @OldAlertsSystemPath = 'mysetup.account.alerts',
        @OldAlertsSystemType = '-view',
        @NewAlertsSystemPath = 'mysetup.alerts',
        @NewAlertsSystemType = '-function'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
  RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Change alerts System Paths to TSystem

-- Expected row counts:
-- TSystem (1 row(s) affected)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

    DECLARE 
        @AlertsSystemId INT,
        @NewAlertsParentSystemId INT


  IF EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @OldAlertsSystemPath and SystemType = @OldAlertsSystemType)
  BEGIN

    SET @NewAlertsParentSystemId = (SELECT TOP 1 SystemId FROM TSystem WHERE SystemPath = 'home.mysetup' and SystemType = '-system')
    SET @AlertsSystemId = (SELECT TOP 1 SystemId FROM TSystem WHERE SystemPath = @OldAlertsSystemPath and SystemType = @OldAlertsSystemType)

    UPDATE s
    SET s.SystemPath = @NewAlertsSystemPath,
        s.SystemType = @NewAlertsSystemType,
        s.ParentId = @NewAlertsParentSystemId
    OUTPUT 
            inserted.[Identifier],
            inserted.[Description],
            inserted.[SystemPath],
            inserted.[SystemType],
            inserted.[ParentId],
            inserted.[Url],
            inserted.[EntityId],
            inserted.[ConcurrencyId],
            inserted.[SystemId],
            @StampActionUpdate,
            @StampDateTime,
            @StampUser,
            inserted.[Order]
    INTO 
            TSystemAudit
            (
                [Identifier],
                [Description],
                [SystemPath],
                [SystemType],
                [ParentId],
                [Url],
                [EntityId],
                [ConcurrencyId],
                [SystemId],
                [StampAction],
                [StampDateTime],
                [StampUser],
                [Order]
            )
    FROM TSystem s
    WHERE s.SystemId = @AlertsSystemId

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

  SELECT @ErrorMessage = ERROR_MESSAGE(),
         @ErrorSeverity = ERROR_SEVERITY(),
         @ErrorState = ERROR_STATE(),
         @ErrorNumber = ERROR_NUMBER(),
         @ErrorLine = ERROR_LINE()

  /*Insert into logging table - IF ANY  */

  IF XACT_STATE() <> 0 AND @starttrancount = 0
    ROLLBACK TRANSACTION

  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;