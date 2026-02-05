-----------------------------------------------------------------------------
--
-- Summary: INTTFF-541 SQL - Income data updates
--
-----------------------------------------------------------------------------
USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER = '5ecaa963-f7c1-41ba-8e80-30ec521f6dd3'
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
	
	
	  -- Update Attributes for GB, Other Income
	  update [factfind].[dbo].[TRefData] 
	  set Attributes = '{\"party_types\":\"Person,Trust,Corporate\",\"ordinal\":\"28\"}'
	  where RefDataId = 64
	  
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