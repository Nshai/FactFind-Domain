USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
		, @Comments VARCHAR(255)
		, @ScottishWidowsPlatform VARCHAR(255) = 'Scottish Widows Platform'
		, @ScottishWidowsPlatformId INT
		, @EmbarkPlatform VARCHAR(255) = 'Embark Investment Services Limited'
		, @EmbarkPlatformId INT
		, @StampUser INT = 0 

/*
Summary
DEF-13549 - Archive and link providers

DatabaseName        TableName      Expected Rows
PolicyManagement	TRefProdProvider	1
PolicyManagement	TLinkedProductProvider	1
*/

SELECT 
	@ScriptGUID = '7D5AB7D9-1F81-47A7-A139-2C25B6F15E8D', 
	@Comments = 'DEF-13549 - Archive and link providers'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

SET @EmbarkPlatformId = (
	SELECT p.RefProdProviderId FROM TRefProdProvider p 
	JOIN CRM..TCRMContact c ON p.CRMContactId = c.CRMContactId 
	WHERE c.CorporateName = @EmbarkPlatform
	)

SET @ScottishWidowsPlatformId = (
	SELECT p.RefProdProviderId FROM TRefProdProvider p 
	JOIN CRM..TCRMContact c ON p.CRMContactId = c.CRMContactId 
	WHERE c.CorporateName = @ScottishWidowsPlatform
	)

IF (@@SERVERNAME LIKE '%SYS%')
BEGIN
	IF (@EmbarkPlatformId IS NULL)
	BEGIN
		EXEC scriptlauncher.dbo.uspCreateprovider @EmbarkPlatform, 'GB'
		SET @EmbarkPlatformId = (
		SELECT p.RefProdProviderId FROM TRefProdProvider p 
		JOIN CRM..TCRMContact c ON p.CRMContactId = c.CRMContactId 
		WHERE c.CorporateName = @EmbarkPlatform
		)
	END

	IF (@ScottishWidowsPlatformId IS NULL)
	BEGIN
		EXEC scriptlauncher.dbo.uspCreateprovider @ScottishWidowsPlatform, 'GB'
		SET @ScottishWidowsPlatformId = (
		SELECT p.RefProdProviderId FROM TRefProdProvider p 
		JOIN CRM..TCRMContact c ON p.CRMContactId = c.CRMContactId 
		WHERE c.CorporateName = @ScottishWidowsPlatform
		)
	END
END

IF @EmbarkPlatformId IS NOT NULL AND @ScottishWidowsPlatformId IS NOT NULL
BEGIN TRY

    BEGIN TRANSACTION

	UPDATE TRefProdProvider
	SET RetireFg = 1
	OUTPUT 
		deleted.ConcurrencyId,
		deleted.CRMContactId,
		deleted.DTCCIdentifier,
		deleted.FundProviderId,
		deleted.IsBankAccountTransactionFeed,
		deleted.IsConsumerFriendly,
		deleted.IsTransactionFeedSupported,
		deleted.NewProdProviderId,
		deleted.RefProdProviderId,
		deleted.RegionCode,
		deleted.RetireFg,
		'U',
		GETUTCDATE(),
		@StampUser
	INTO TRefProdProviderAudit(
		ConcurrencyId,
		CRMContactId,
		DTCCIdentifier,
		FundProviderId,
		IsBankAccountTransactionFeed,
		IsConsumerFriendly,
		IsTransactionFeedSupported,
		NewProdProviderId,
		RefProdProviderId,
		RegionCode,
		RetireFg,
		StampAction,
		StampDateTime,
		StampUser
	)
	WHERE RefProdProviderId = @EmbarkPlatformId

	INSERT INTO TLinkedProductProvider (LinkedRefProdProviderId, RefProdProviderId)
	OUTPUT 
		inserted.LinkedProductProviderId, 
		inserted.LinkedRefProdProviderId, 
		inserted.RefProdProviderId, 
		'C', 
		GETUTCDATE(), 
		@StampUser
	INTO TLinkedProductProviderAudit(
		LinkedProductProviderId,
		LinkedRefProdProviderId,
		RefProdProviderId,
		StampAction,
		StampDateTime,
		StampUser
	)
	VALUES (@ScottishWidowsPlatformId, @EmbarkPlatformId)

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