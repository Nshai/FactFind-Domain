-----------------------------------------------------------------------------
--
-- Summary: AIOPFP-293 SQL - Add missing Incomes for US region
--
-----------------------------------------------------------------------------
USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER = '81356FBC-CFE6-4F80-8203-AB18C9AB655D'
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

	SET IDENTITY_INSERT TRefData ON
	
	INSERT INTO TRefData (RefDataId, [Name],[Type],[Property],[RegionCode],[Attributes])
	VALUES 
	(102,'Income earned as a partner/sole proprietor','income','category','US','{\"party_types\":\"Person\",\"ordinal\":\"2\"}'),
	(103,'Basic Income','income','category','US','{\"party_types\":\"Person\",\"ordinal\":\"3\"}'),	
	(104,'Dividends','income','category','US','{\"party_types\":\"Person\",\"ordinal\":\"4\"}')	

	SET IDENTITY_INSERT TRefData OFF

    -- Record execution so the script won't run again
    INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
    VALUES (@ScriptGUID, 'AIOPFP-293 SQL - Add missing Incomes for US region')
 
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