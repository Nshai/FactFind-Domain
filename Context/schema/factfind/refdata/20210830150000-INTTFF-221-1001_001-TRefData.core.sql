-----------------------------------------------------------------------------
--
-- Summary: INTTFF-221 1. Trust FF > 'Add Asset' popups / 'Edit Asset' screen from Plans > Link an Asset to an Income
--
-----------------------------------------------------------------------------
USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER = 'ECC615F2-7459-4E66-810F-D9F65B571071'
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
	
	
	  -- Update Name from Net Profit to Profit
	  update [factfind].[dbo].[TRefData] 
	  set Name = 'Profit'
	  where RefDataId IN (11,22) and Type='income' and Property='category'
	  
	  -- Record execution so the script won't run again
      INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
      VALUES (@ScriptGUID, 'Change Attributes Data in FactFind.TrefData')

	
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