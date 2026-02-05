USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @RefProdProviderId int = 4982

/*
Summary
Archive Punter Southall SIPP Limited

DatabaseName        TableName      Expected Rows
PolicyManagement    TRefProdProvider    1
*/


SELECT 
    @ScriptGUID = '12485C60-EA11-4226-BF14-EF03BB673216', 
    @Comments = 'DEF-11391 Archive Punter Southall SIPP Limited'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

    BEGIN TRANSACTION

    EXEC SpNAuditRefProdProvider 0, @RefProdProviderId, 'U'

    UPDATE TRefProdProvider
    SET RetireFg = 1
    WHERE RefProdProviderId = @RefProdProviderId

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION

END TRY
BEGIN CATCH
    
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;