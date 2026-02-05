-----------------------------------------------------------------------------
-- Table: Administration.TEntity
-- Addition of the Plan entity type to support plan security.
-----------------------------------------------------------------------------

USE Administration

DECLARE @ScriptGuid VARCHAR(50) = 'A5C1BA1D-C118-4160-AC82-DF633E60B68C'

-- check if this script has already run
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGuid = @ScriptGuid)
	RETURN

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT

BEGIN TRY
	SELECT @starttrancount = @@TRANCOUNT

	IF (@starttrancount = 0)
		BEGIN TRANSACTION

	SET IDENTITY_INSERT TEntity ON

	INSERT INTO TEntity([EntityId], [Identifier], [Descriptor], [Db], [ConcurrencyId])
	SELECT 9, 'Plan', 'Plan', 'PolicyManagement', 1

	SET IDENTITY_INSERT TEntity OFF

	-- record execution so the script won't run again
	INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp)
	VALUES (@ScriptGuid, 'Load of plan entity for table TEntity', null, GETDATE() )

	IF @starttrancount = 0
		COMMIT TRANSACTION

END TRY
BEGIN CATCH
	DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT

	SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

