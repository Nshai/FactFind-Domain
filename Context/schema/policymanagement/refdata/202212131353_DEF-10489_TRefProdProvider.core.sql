USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)
        , @RefProdProviderId int = 5007
        , @RegionCode varchar(50) = 'gb'

SELECT 
    @ScriptGUID = '3B636412-D3A6-499C-BA7F-D62795BB6C1E',
    @Comments = 'DEF-10489 Archive provider Morningstar Wealth Platform'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

/*
SUMMARY
Archive provider Morningstar Wealth Platform

Database            Table               Affected Rows
PolicyManagement    TRefProdProvider    1
*/


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

            EXEC SpNAuditRefProdProvider 0, @RefProdProviderId, 'U'

            UPDATE TRefProdProvider
            SET RetireFg = 1
            WHERE RefProdProviderId = @RefProdProviderId AND RegionCode = @RegionCode

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