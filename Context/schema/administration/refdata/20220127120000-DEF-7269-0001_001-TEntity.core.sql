-----------------------------------------------------------------------------
-- Table: Administration.TEntity
-- Removal of the Plan entity type as it is appearing in IO. 
-----------------------------------------------------------------------------
USE Administration

DECLARE @ScriptGuid VARCHAR(50) = 'D8D06E87-A303-43F3-90DC-AF53159BA976'

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
	
	DELETE FROM TPolicy 
	WHERE EntityId = (SELECT EntityId FROM TEntity WHERE Identifier = 'Plan')

	DELETE FROM TEntity
	WHERE Identifier = 'Plan'

	-- record execution so the script won't run again
	INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
	VALUES (@ScriptGuid, 'Remove plan entity for table TEntity', null, GETDATE() )
 
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

