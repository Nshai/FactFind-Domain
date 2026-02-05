USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
	  , @CorporateName VARCHAR(255) = 'Cardale Asset Management Ltd'
	  , @CRMContactId INT
	  , @CorporateId INT
	  , @RefProdProviderId INT

/*
Summary
Archive Cardale Asset Management Ltd

DatabaseName        TableName				Expected Rows
PolicyManagement	TRefProdProvider		1
CRM					TCRMContact				1
CRM					TCorporate				1
*/

SELECT 
	@ScriptGUID = 'BFA1A677-EADD-49C6-822E-875F9E3B9744',
	@Comments = 'DEF-16152 - Archive Cardale Asset Management Ltd'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

SET @RefProdProviderId = (
	SELECT TOP 1 a.RefProdProviderId
	FROM TRefProdProvider a 
	JOIN CRM..TCRMContact b ON a.CRMContactId = b.CRMContactId
	WHERE b.CorporateName = @CorporateName
)

SET @CRMContactId = (
	SELECT TOP 1 CRMContactId
	FROM TRefProdProvider
	WHERE RefProdProviderId = @RefProdProviderId
)

SET @CorporateId = (
	SELECT TOP 1 CorporateId
	FROM CRM..TCRMContact
	WHERE CRMContactId = @CRMContactId
)

IF @RefProdProviderId IS NOT NULL AND @CRMContactId IS NOT NULL AND @CorporateId IS NOT NULL
BEGIN TRY

    BEGIN TRANSACTION

    EXEC SpNAuditRefProdProvider 0, @RefProdProviderId, 'U'

	UPDATE TRefProdProvider
	SET RetireFg = 1
	WHERE RefProdProviderId = @RefProdProviderId

	EXEC CRM..SpNAuditCRMContact 0, @CRMContactId, 'U'

	UPDATE CRM..TCRMContact
	SET ArchiveFg = 1
	WHERE CRMContactId = @CRMContactId

	EXEC CRM..SpNAuditCorporate 0 , @CorporateId, 'U'

	UPDATE CRM..TCorporate
	SET ArchiveFg = 1
	WHERE CorporateId = @CorporateId
			
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