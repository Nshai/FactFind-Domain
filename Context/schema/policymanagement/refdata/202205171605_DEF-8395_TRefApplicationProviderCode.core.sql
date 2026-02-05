USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT 
	@ScriptGUID = '810F9A59-89E8-45DE-A516-6DB4A1AEA198',
	@Comments = 'DEF-8395 Update SB provider mapping'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Update SB provider mapping for VitalityLife

-- Expected row counts:
--(1 row(s) affected)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int,
        @RefApplicationProviderCodeId int = 3596,
        @RefProdProviderId int = 2624

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

		    -- BEGIN DATA UPDATE

            EXEC SpNAuditRefApplicationProviderCode 0, @RefApplicationProviderCodeId, 'U'

            UPDATE TRefApplicationProviderCode
            SET 
                ConcurrencyId += 1, 
                RefProdProviderId = @RefProdProviderId
            wHERE RefApplicationProviderCodeId = @RefApplicationProviderCodeId

			-- BEGIN DATA UPDATE
			
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

       /*Insert into logging table - IF ANY	*/

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION
    
       RAISERROR ('ErrorNo: %d, Severity: %d, State: %d, Procedure: %s, Line %d, Message %s',1,1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProc, @ErrorLine, @ErrorMessage);

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;