USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @Name varchar(50) = 'PSigma Investment Management'
        , @StampAction char = 'U'
        , @StampUser int = 0

DECLARE @CRMContactId int = (
            SELECT CRMContactId 
            FROM CRM..TCRMContact 
            WHERE CorporateName = @Name AND IndClientId = 0
        )

DECLARE @RefProdProviderId int = (
			SELECT RefProdProviderId
			FROM TRefProdProvider
			WHERE CRMContactId = @CRMContactId
		)

/*
Summary
Archive provider with incorrect name

DatabaseName        TableName      Expected Rows
PolicyManagement    TRefProdProvider    1
CRM                 TCRMContact    1
*/

SELECT 
    @ScriptGUID = '68E99235-5D49-463D-BB68-98F9C903629C',
    @Comments = 'DEF-9030 Archive provider'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

    BEGIN TRANSACTION

    EXEC SpNAuditRefProdProvider @StampUser, @RefProdProviderId, @StampAction

    UPDATE TRefProdProvider
    SET ConcurrencyId += 1, RetireFg = 1
    WHERE RefProdProviderId = @RefProdProviderId

    EXEC CRM.dbo.SpNAuditCRMContact @StampUser, @CRMContactId, @StampAction

    UPDATE CRM..TCRMContact
    SET ConcurrencyId += 1, ArchiveFg = 1
    WHERE CRMContactId = @CRMContactId

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
