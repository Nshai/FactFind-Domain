USE administration;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = '543BCAD3-23F9-4486-9003-0A58CC28E149',
    @Comments = 'AIOMFE-1497 - Add TEntitlementDataSyncTask table.'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary:
--   Initial populate TEntitlementDataSyncTask table
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

            DECLARE @CurrentDateTime DATETIME = GETUTCDATE(),
            @CompletedStatusId INT = 3

            INSERT INTO [dbo].[TEntitlementDataSyncTask]
            (
                [SourceTable]
                , [LastAuditId]
                , [Status]
            )
            OUTPUT
                inserted.[EntitlementDataSyncTaskId]
                , inserted.[SourceTable]
                , inserted.[LastAuditId]
                , inserted.[Status]
                , 'C'
                , @CurrentDateTime
                , 0
            INTO [administration]..[TEntitlementDataSyncTaskAudit]
            (
                [EntitlementDataSyncTaskId]
                , [SourceTable]
                , [LastAuditId]
                , [Status]
                , [StampAction]
                , [StampDateTime]
                , [StampUser]
            )
            VALUES
                ('TUser', 0, @CompletedStatusId),
                ('TSystem', 0, @CompletedStatusId),
                ('TKey', 0, @CompletedStatusId),
                ('TMembership', 0, @CompletedStatusId),
                ('TRefLicenseTypeToSystem', 0, @CompletedStatusId)

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

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;