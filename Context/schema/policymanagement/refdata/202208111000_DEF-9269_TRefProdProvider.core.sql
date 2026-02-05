USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)
        , @ProviderName varchar(50) = 'LGT Vestra LLP'
        , @RefProdProviderId int

SELECT 
    @ScriptGUID = 'AE23B5D3-0FFB-4C69-8716-B1E8D9F3955E',
    @Comments = 'DEF-9269 - Unarchive provider'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Unarchive provider LGT Vestra LLP gb

-- Expected row counts:
--(1 row(s) affected)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    SET @RefProdProviderId = (
            SELECT RefProdProviderId FROM TRefProdProvider p WITH (NOLOCK)
            JOIN CRM..TCRMContact c WITH (NOLOCK) on p.CRMContactId = c.CRMContactId
            WHERE c.CorporateName = @ProviderName
            )

    IF @starttrancount = 0
        BEGIN TRANSACTION

        EXEC SpNAuditRefProdProvider 0, @RefProdProviderId, 'U'

        UPDATE TRefProdProvider
        SET ConcurrencyId += 1, RetireFg = 0
        WHERE RefProdProviderId = @RefProdProviderId

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