USE administration

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = 'B19E6D44-A207-4BC6-A860-739E459334E1',
    @Comments = 'INTCA2-811 Fix AWP -> Client/Leads -> Tasks -> Tasks And Appts'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary:
-- Update TSystem
-- Update TRefLicenseType
-- Expected row counts: ~ 5000 row(s) affected
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT
DECLARE @CurrentDateTime DATETIME = GETUTCDATE()
DECLARE @StampUser INT = 0

DECLARE @SystemIdsTmp TABLE (SystemId int, ParentId int)
DECLARE @SystemIdsToHideTmp TABLE (SystemId int)

INSERT INTO @SystemIdsTmp
    SELECT SystemId, ParentId FROM TSystem
    WHERE SystemPath IN (
       'adviserworkplace.clients.tasks.activityhistory',
       'adviserworkplace.leads.tasks.activityhistory'
   );

INSERT INTO @SystemIdsToHideTmp
    SELECT SystemId FROM TSystem
    WHERE SystemPath IN (
       'adviserworkplace.leads.tasks.taskandappts',
       'adviserworkplace.clients.tasks.tasksandappts'
   );

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION
            
            UPDATE TSystem
            SET SystemType='-liogroup', ConcurrencyId = ConcurrencyId + 1
            OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
            INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
            WHERE SystemId IN (SELECT SystemId FROM @SystemIdsToHideTmp)

            DELETE FROM TRefLicenseTypeToSystem
            OUTPUT deleted.RefLicenseTypeId, deleted.SystemId, 1, deleted.RefLicenseTypeToSystemId, 'D', @CurrentDateTime, @StampUser
            INTO TRefLicenseTypeToSystemAudit (RefLicenseTypeId, SystemId, ConcurrencyId, RefLicenseTypeToSystemId, StampAction, StampDateTime, StampUser)
            WHERE SystemId IN (SELECT SystemId FROM @SystemIdsToHideTmp)

            UPDATE TSystem
            SET SystemType='-view', ConcurrencyId = ConcurrencyId + 1
            OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
            INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
            WHERE SystemId IN (SELECT SystemId FROM @SystemIdsTmp)

            INSERT INTO TRefLicenseTypeToSystem (RefLicenseTypeId, SystemId, ConcurrencyId)
            OUTPUT inserted.RefLicenseTypeId, inserted.SystemId, 1, inserted.RefLicenseTypeToSystemId, 'C', @CurrentDateTime, @StampUser
            INTO TRefLicenseTypeToSystemAudit (RefLicenseTypeId, SystemId, ConcurrencyId, RefLicenseTypeToSystemId, StampAction, StampDateTime, StampUser)
            SELECT lts.RefLicenseTypeId, s.SystemId, 1
            FROM @SystemIdsTmp s
            INNER JOIN TRefLicenseTypeToSystem lts ON s.ParentId = lts.SystemId

            UPDATE TSystem
            SET Description='Contributions/Premiums', ConcurrencyId = ConcurrencyId + 1
            OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
            INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
            WHERE SystemPath = 'adviserworkplace.clients.plans.contribution'

            UPDATE TSystem
            SET Description='Pension Income', ConcurrencyId = ConcurrencyId + 1
            OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
            INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
            WHERE SystemPath = 'adviserworkplace.clients.plans.pension'

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

INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN; 