USE administration;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
		, @Comments VARCHAR(255)
		, @ErrorMessage VARCHAR(MAX)

SELECT
	@ScriptGUID = 'B0696BF5-2739-4DD5-97BD-4A31472DE6D7',
	@Comments = 'AIOAA-138 Add missing and update existing System Paths'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

-----------------------------------------------------------------------------------------------
-- Summary:
--   Add alerts System Paths to TSystem
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
	SELECT @starttrancount = @@TRANCOUNT

	IF @starttrancount = 0
		BEGIN TRANSACTION

	-- BEGIN DATA INSERT/UPDATE/DELETE

	DECLARE @BatchSize INT = 5000;
	DECLARE @Rows INT = @BatchSize;
	DECLARE @SumRows INT = 0;
	DECLARE @ResultMessage varchar(500);
	DECLARE @CurrentDateTime datetime = GETUTCDATE()
	DECLARE @StampUser int = 0

	-- ADD new SystemPaths to TSystem & assigned those to all licenses

	IF (NOT EXISTS(SELECT 1 FROM TSystem WHERE SystemPath = 'mysetup.account.alerts'))
	BEGIN

		DECLARE @ParentSystemId INT

		SELECT @ParentSystemId = SystemId FROM TSystem WHERE SystemPath = 'mysetup.account'

		DECLARE @SystemIdsTmp TABLE (SystemId int, ParentId int)

		INSERT INTO TSystem (Identifier, Description, SystemPath, SystemType, ParentId, Url, ConcurrencyId)
		OUTPUT inserted.SystemId, inserted.ParentId
		INTO @SystemIdsTmp (SystemId, ParentId)
		VALUES ('alerts', 'Alerts', 'mysetup.account.alerts', '-view', @ParentSystemId, NULL, 1);

		INSERT INTO TSystemAudit(SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser)
		SELECT SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, 'C', @CurrentDateTime, @StampUser
		FROM TSystem
		WHERE SystemId IN (SELECT SystemId FROM @SystemIdsTmp)

		INSERT INTO TRefLicenseTypeToSystem (RefLicenseTypeId, SystemId, ConcurrencyId)
		OUTPUT inserted.RefLicenseTypeId, inserted.SystemId, 1, inserted.RefLicenseTypeToSystemId, 'C', @CurrentDateTime, @StampUser
		INTO TRefLicenseTypeToSystemAudit (RefLicenseTypeId, SystemId, ConcurrencyId, RefLicenseTypeToSystemId, StampAction, StampDateTime, StampUser)
		SELECT l.RefLicenseTypeId, s.SystemId, 1
			FROM TRefLicenseType l
			CROSS JOIN @SystemIdsTmp s
			INNER JOIN TRefLicenseTypeToSystem lts ON s.ParentId = lts.SystemId AND l.RefLicenseTypeId = lts.RefLicenseTypeId

		-- END DATA INSERT/UPDATE/DELETE
	END

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