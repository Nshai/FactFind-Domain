-----------------------------------------------------------------------------
--
-- Summary: INTTFF-191 SQL - Fix region codes in Income category reference data
--
-----------------------------------------------------------------------------

USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER = '4419D600-7A03-4BE8-920C-34C7EEAA693D'
DECLARE @StartTranCount int

-- Check if this script has already run
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGuid = @ScriptGUID) 
	RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON

BEGIN TRY
    SELECT @StartTranCount = @@TRANCOUNT

    IF (@StartTranCount = 0)
    BEGIN TRANSACTION
 
		UPDATE [TRefData]
		SET [RegionCode] = 'GB'
		WHERE [RegionCode] = 'UK'and [Type] = 'income' and [Property] = 'category'

		UPDATE [TRefData]
		SET [RegionCode] = 'AU'
		WHERE [RegionCode] = 'AUS' and [Type] = 'income' and [Property] = 'category'


        -- Record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
        VALUES (@ScriptGUID, 'INTTFF-191 SQL - Fix region codes in Income category reference data')
 
	IF (@StartTranCount = 0)
		COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH
 
SET XACT_ABORT OFF
SET NOCOUNT OFF
