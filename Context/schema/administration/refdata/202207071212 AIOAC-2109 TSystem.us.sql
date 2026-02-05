USE [administration];


DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @SystemID VARCHAR(MAX)
      , @ParentSystemID VARCHAR(MAX)
      , @StampDateTime DATETIME
      , @StampUser INT


--Use the line below to generate a GUID.
--Please DO NOT make it part of the script. You should only generate the GUID once.
--SELECT NEWID()

SELECT 
    @ScriptGUID = '46FB6A75-A52C-4044-92FA-0B4D36E6BC4C',
    @Comments = 'AIOAC-2109 - Change permissions(security key) for account opening actions',
    @StampDateTime = GETUTCDATE(),
    @StampUser = 0
/*
	NOTE: By default the scripts will run on ALL environments as part of a data refresh
	If this script needs to be run on a specific environment, change and enable this. 
*/

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Rename security key to manage access to Account Opening functionality

-- Expected row counts: - if you know this
-- TSystem (1 row(s) affected)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

            SET @ParentSystemID = (SELECT SystemId FROM TSystem WHERE SystemPath = 'adviserworkplace.clients.plans')
            SET @SystemID = (SELECT SystemId FROM TSystem WHERE SystemPath = 'adviserworkplace.clients.openapplication')

            UPDATE TSystem
            SET SystemPath = 'adviserworkplace.clients.plans.openapplication', ParentId = @ParentSystemID, ConcurrencyId = ConcurrencyId + 1
            OUTPUT deleted.SystemId, deleted.Identifier, deleted.Description, deleted.SystemPath, deleted.SystemType, deleted.ParentId, 1, 'U', @StampDateTime, @StampUser, deleted.Url
            INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
            WHERE SystemId = @SystemID

			INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    IF @starttrancount = 0 
        COMMIT TRANSACTION

END TRY
BEGIN CATCH

       DECLARE @ErrorSeverity INT
       DECLARE @ErrorState INT
       DECLARE @ErrorLine INT
       DECLARE @ErrorNumber INT

       SELECT @ErrorMessage = ERROR_MESSAGE(),
       @ErrorSeverity = ERROR_SEVERITY(),
       @ErrorState = ERROR_STATE(),
       @ErrorNumber = ERROR_NUMBER(),
       @ErrorLine = ERROR_LINE()

       /*Insert into logging table - IF ANY	*/

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION
    
       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;