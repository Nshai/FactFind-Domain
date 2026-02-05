USE administration

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = 'CDF90DF6-C787-4238-BE1B-2C608D234A35',
    @Comments = 'PA-14599 Create script to remove Unrealized Gain Loss permissions'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary:
-- Delete 2 rows in TSystem
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON

DECLARE @CurrentDateTime DATETIME = GETUTCDATE()
DECLARE @StampUser INT = 0

DECLARE 
      @PlansPermissionsUnrealizedGainLossSystemPath varchar(max),
      @PlansPermissionsUnrealizedGainLossFullListSystemPath varchar(max),
      @SystemType varchar(10)
       
BEGIN TRY

    SET @PlansPermissionsUnrealizedGainLossSystemPath = 'adviserworkplace.clients.plans.unrealizedgainloss'
    SET @PlansPermissionsUnrealizedGainLossFullListSystemPath = 'adviserworkplace.clients.plans.unrealizedgainlossfulllist'
    SET @SystemType = '-view'

        BEGIN TRANSACTION

            DECLARE @PlansPermissionsUnrealizedGainLossSystemId int
            DECLARE @PlansPermissionsUnrealizedGainLossFullListSystemId int

            Set @PlansPermissionsUnrealizedGainLossSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @PlansPermissionsUnrealizedGainLossSystemPath and SystemType=@SystemType)
            Set @PlansPermissionsUnrealizedGainLossFullListSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @PlansPermissionsUnrealizedGainLossFullListSystemPath and SystemType=@SystemType)

            DELETE FROM TRefLicenseTypeToSystem
            OUTPUT deleted.RefLicenseTypeId, deleted.SystemId, 1, deleted.RefLicenseTypeToSystemId, 'D', @CurrentDateTime, @StampUser
            INTO TRefLicenseTypeToSystemAudit (RefLicenseTypeId, SystemId, ConcurrencyId, RefLicenseTypeToSystemId, StampAction, StampDateTime, StampUser)
            WHERE SystemId in(@PlansPermissionsUnrealizedGainLossSystemId, @PlansPermissionsUnrealizedGainLossFullListSystemId)

            DELETE FROM TControllerActionToTSystem
            WHERE SystemId in(@PlansPermissionsUnrealizedGainLossSystemId, @PlansPermissionsUnrealizedGainLossFullListSystemId)

            DELETE FROM TServiceActionToTSystem
            WHERE SystemId in(@PlansPermissionsUnrealizedGainLossSystemId, @PlansPermissionsUnrealizedGainLossFullListSystemId)

            DELETE FROM TKEY
            OUTPUT deleted.RightMask, deleted.SystemId, deleted.UserId, deleted.RoleId,1, deleted.KeyId, 'D', @CurrentDateTime, @StampUser
            INTO TKeyAudit (RightMask, SystemId, UserId, RoleId, ConcurrencyId, KeyId, StampAction, StampDateTime, StampUser)
            WHERE SystemId in(@PlansPermissionsUnrealizedGainLossSystemId, @PlansPermissionsUnrealizedGainLossFullListSystemId)

            DELETE FROM TSystem
            OUTPUT deleted.SystemId, deleted.Identifier, deleted.Description, deleted.SystemPath, deleted.SystemType, deleted.ParentId, 1, 'D', @CurrentDateTime, @StampUser, deleted.Url
            INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
            WHERE SystemId in(@PlansPermissionsUnrealizedGainLossSystemId, @PlansPermissionsUnrealizedGainLossFullListSystemId)

            INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

        COMMIT TRANSACTION
END TRY
BEGIN CATCH
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT
    DECLARE @ErrorLine INT
    DECLARE @ErrorNumber INT
    DECLARE @ErrorProc sysname

    SELECT @ErrorMessage = ERROR_MESSAGE(),
    @ErrorSeverity = ERROR_SEVERITY(),
    @ErrorState = ERROR_STATE(),
    @ErrorNumber = ERROR_NUMBER(),
    @ErrorLine = ERROR_LINE(),
    @ErrorProc = ERROR_PROCEDURE()

    /*Insert into logging table - IF ANY    */

    ROLLBACK TRANSACTION

    RAISERROR ('ErrorNo: %d, Severity: %d, State: %d, Procedure: %s, Line %d, Message %s',
        1,1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProc, @ErrorLine, @ErrorMessage);

    RETURN;
END CATCH

SET NOCOUNT OFF

RETURN;