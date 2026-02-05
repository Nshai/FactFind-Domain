-----------------------------------------------------------------------------
--
-- Summary: INTTFF-103 SQL - Add additional Income category reference data
--
-----------------------------------------------------------------------------

USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER = '716D94F4-DE23-4148-B6EA-95129611832A'
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
 
		-- First corrections to the existing income type reference data
		DELETE FROM [TRefData]
		WHERE [RefDataId] IN (4, 15)

		UPDATE [TRefData]
		SET [Attributes] = '{\"party_types\":\"Person,Trust,Corporate\"}'
		WHERE [RefDataId] IN (10, 21)

		UPDATE [TRefData]
		SET [Attributes] = '{\"party_types\":\"Trust,Corporate\"}'
		WHERE [RefDataId] IN (11, 22)

		UPDATE [TRefData]
		SET [RegionCode] = 'UK'
		WHERE [RegionCode] = 'GB'

        -- Record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
        VALUES (@ScriptGUID, 'Update Income category ref data based on region')
 
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