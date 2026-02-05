USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
		, @Comments VARCHAR(255)
		, @Embark VARCHAR(255) = 'Embark Investment Services Limited'
		, @RefProdProviderId INT = 0
		, @CRMContactId INT = 0
		, @CorporateId INT = 0
		, @StampAction CHAR = 'U'

/*
Summary
Re-Archive Embark Investment Services Limited

DatabaseName        TableName      Expected Rows
PolicyManagement	TRefProdProvider	1
CRM	TCRMContact	1
CRM	TCorporate	1
*/

SELECT 
	@ScriptGUID = 'B3082DDD-5548-4041-AFCC-47BEDA25DB6A', 
	@Comments = 'DEF-15107 Re-Archive Embark Investment Services Limited'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

SET @CRMContactId = 
	(
		SELECT TOP 1 a.CRMContactId FROM CRM..TCRMContact a WITH (NOLOCK)
		JOIN TRefProdProvider b WITH (NOLOCK) ON a.CRMContactId = b.CRMContactId
		WHERE a.CorporateName = @Embark
		ORDER BY 1 DESC
	)

SET @CorporateId = 
	(
		SELECT TOP 1 a.CorporateId FROM CRM..TCorporate a WITH (NOLOCK)
		JOIN CRM..TCRMContact b WITH (NOLOCK) on a.CorporateId = b.CorporateId
		WHERE b.CRMContactId = @CRMContactId
	)

SET @RefProdProviderId = 
	(
		SELECT TOP 1 a.RefProdProviderId FROM TRefProdProvider a WITH (NOLOCK)
		JOIN CRM..TCRMContact b WITH (NOLOCK) ON a.CRMContactId = b.CRMContactId
		JOIN CRM..TCorporate c WITH (NOLOCK) on b.CorporateId = c.CorporateId
		WHERE b.CRMContactId = @CRMContactId AND c.CorporateId = @CorporateId
	)

IF @RefProdProviderId > 0
BEGIN TRY

    BEGIN TRANSACTION

	EXEC SpNAuditRefProdProvider 0, @RefProdProviderId, @StampAction
	UPDATE TRefProdProvider
	SET RetireFg = 1
	WHERE RefProdProviderId = @RefProdProviderId

	EXEC CRM..SpNAuditCRMContact 0, @CRMContactId, @StampAction
	UPDATE CRM..TCRMContact
	SET ArchiveFg = 1
	WHERE CRMContactId = @CRMContactId

	EXEC CRM..SpNAuditCorporate 0, @CorporateId, @StampAction
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