USE administration

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = 'EED00453-C29B-4BA4-A8DE-F5EB2CB08AFC',
    @Comments = 'INTCA2-836 Delete duplicate keys in TSystem table'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary:
-- Delete 5 rows in TSystem
-- Delete rows in TRefLicenseType
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT
DECLARE @CurrentDateTime DATETIME = GETUTCDATE()
DECLARE @StampUser INT = 0

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

            DELETE FROM TRefLicenseTypeToSystem
            OUTPUT deleted.RefLicenseTypeId, deleted.SystemId, 1, deleted.RefLicenseTypeToSystemId, 'D', @CurrentDateTime, @StampUser
            INTO TRefLicenseTypeToSystemAudit (RefLicenseTypeId, SystemId, ConcurrencyId, RefLicenseTypeToSystemId, StampAction, StampDateTime, StampUser)
            WHERE SystemId IN (334, 359, 358, 663, 682)

            DELETE FROM TSystem
            OUTPUT deleted.SystemId, deleted.Identifier, deleted.Description, deleted.SystemPath, deleted.SystemType, deleted.ParentId, 1, 'D', @CurrentDateTime, @StampUser, deleted.Url
            INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
            WHERE SystemId IN (334, 359, 358, 663, 682)

            INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    IF @starttrancount = 0
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

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
       ROLLBACK TRANSACTION

    RAISERROR ('ErrorNo: %d, Severity: %d, State: %d, Procedure: %s, Line %d, Message %s',
        1,1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProc, @ErrorLine, @ErrorMessage);

    RETURN;
END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;