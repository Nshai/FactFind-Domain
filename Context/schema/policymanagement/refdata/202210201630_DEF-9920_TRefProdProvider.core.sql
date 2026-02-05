USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = '4F9BDD00-03FF-4942-BBB6-4F52E4D1824F'
    , @Comments = 'DEF-9920 Edit existing provider name and archive flag, and archive unnecessary provider.'

IF EXISTS (SELECT 1
FROM TExecutedDataScript
WHERE ScriptGUID = @ScriptGUID)
    RETURN;

/*
    Summary: Edit 2 rows in CRM.dbo.TCRMContact and 2 rows in PolicyManagement..TRefProdProvider
    Expected row counts:
    (4 rows affected)
*/

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY

    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
    BEGIN TRANSACTION

        UPDATE CRM..TCRMContact
        SET ArchiveFg=0, CorporateName='Psigma Investment Management', ConcurrencyId += 1
        WHERE CRMContactId=140676

        UPDATE PolicyManagement..TRefProdProvider
        SET RetireFg=0
        WHERE CRMContactId=140676

        UPDATE CRM..TCRMContact
        SET ArchiveFg=1, ConcurrencyId += 1
        WHERE CRMContactId=34672196

        UPDATE PolicyManagement..TRefProdProvider
        SET RetireFg=1
        WHERE CRMContactId=34672196

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
