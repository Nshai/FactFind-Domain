USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @RefProdProviderId int
        , @ProviderName varchar(50) = 'Brewin Dolphin Securities'

/*
Summary
Archive provider Brewin Dolphin Securities 

DatabaseName        TableName      Expected Rows
PolicyManagement    TRefProdProvider    1
*/

SELECT 
    @ScriptGUID = '56C0F2A8-6F53-4293-860F-4A1B9960035B', 
    @Comments = 'DEF-12704 Archive provider Brewin Dolphin Securities'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON
SET @RefProdProviderId = (
    SELECT TOP 1 p.RefProdProviderId 
    FROM TRefProdProvider p 
    JOIN CRM..TCRMContact c ON p.CRMContactId = c.CRMContactId
    WHERE c.CorporateName = @ProviderName
    ORDER BY 1 DESC
    )

BEGIN TRY

    BEGIN TRANSACTION

    IF @RefProdProviderId > 1
    BEGIN
        UPDATE TRefProdProvider
        SET RetireFg = 1
        WHERE RefProdProviderId = @RefProdProviderId
    END

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