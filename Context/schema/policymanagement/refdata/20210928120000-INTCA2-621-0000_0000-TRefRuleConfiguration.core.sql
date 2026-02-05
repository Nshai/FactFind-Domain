USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
		, @Comments VARCHAR(255)
		, @ErrorMessage VARCHAR(MAX)

SELECT
	@ScriptGUID = '0D182D8C-7B5B-439A-B185-A5EDC2B58EAF',
	@Comments = 'INTCA2-621 TRefRuleConfiguration'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

-----------------------------------------------------------------------------------------------
-- Summary:
--   Update RuleName in TRefRuleConfiguration
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
	SELECT @starttrancount = @@TRANCOUNT

	IF @starttrancount = 0
		BEGIN TRANSACTION

			UPDATE TRefRuleConfiguration
				SET RuleName = 'By default, Tax is exempt on Add Fee and Create Fee Template screen'
			WHERE RefRuleConfigurationId = 17 AND RuleName = 'By default, VAT is exempt on Add Fee and Create Fee Template screen';

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