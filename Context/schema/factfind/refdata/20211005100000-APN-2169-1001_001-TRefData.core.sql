-----------------------------------------------------------------------------
--
-- Summary: APN-2169 SQL - Add Income ref data for US region
--
-----------------------------------------------------------------------------
USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER = '1A69815F-FF82-4BE4-9EE7-C017D7D054A3'
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
	VALUES (101,'Wage/Salary (net)','income','category','US','{\"party_types\":\"Person\",\"ordinal\":\"1\"}')	

	SET IDENTITY_INSERT TRefData OFF

    -- Record execution so the script won't run again
    INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
    VALUES (@ScriptGUID, 'APN-2169 SQL - Add Income ref data for US region')
 
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