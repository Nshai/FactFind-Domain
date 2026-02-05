USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
		, @Comments VARCHAR(255)
		, @CorporateName VARCHAR(255) = 'Quilter Cheviot Limited'
		, @RefProdProviderId INT
		, @CorporateId INT
		, @CRMContactId INT

/*
Summary
DEF-13603 - Archive Quilter Cheviot

DatabaseName        TableName      Expected Rows
PolicyManagement	TRefProdProvider	1
CRM					TCRMContact			1
CRM					TCorporate			1
*/

SELECT 
	@ScriptGUID = 'DE7F6792-4BAC-4521-BA4C-D24941328FFC', 
	@Comments = 'DEF-16377 - Archive Quilter Cheviot'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

SET @RefProdProviderId = (
	SELECT TOP 1 RefProdProviderId 
	FROM TRefProdProvider p 
	JOIN CRM..TCRMContact c ON p.CRMContactId = c.CRMContactId 
	WHERE c.CorporateName = @CorporateName
	)

SET @CRMContactId = (
	SELECT TOP 1 CRMContactId
FROM CRM.dbo.TCRMContact a
	WHERE CorporateName = @CorporateName AND a.CRMContactType = 1
)

SET @CorporateId = (
	SELECT TOP 1 CorporateId
	FROM CRM.dbo.TCRMContact
	WHERE CRMContactId = @CRMContactId 
)

IF @RefProdProviderId IS NOT NULL AND @CorporateId IS NOT NULL AND @CRMContactId IS NOT NULL
BEGIN TRY

    BEGIN TRANSACTION

	EXEC SpNAuditRefProdProvider 0, @RefProdProviderId, 'U'

    UPDATE TRefProdProvider
	SET RetireFg = 1
	WHERE RefProdProviderId = @RefProdProviderId

	EXEC CRM.dbo.SpNAuditCRMContact 0, @CRMContactId, 'U'

	UPDATE CRM.dbo.TCRMContact
	SET ArchiveFg = 1
	WHERE CRMContactId = @CRMContactId

	EXEC CRM.dbo.SpNAuditCorporate 0, @CorporateId, 'U'

	UPDATE CRM.dbo.TCorporate
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