-----------------------------------------------------------------------------
--
-- Summary: INTTFF-2142 1. New income type for Trust and Corporate party type in UK environment.
--
-----------------------------------------------------------------------------
USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER
	  , @Comments VARCHAR(255)
DECLARE @StartTranCount int


SELECT 
	@ScriptGUID = 'C60BFAE5-4A14-40EC-AE54-6EE8B3E9D10B',
	@Comments = 'Add new income type for Trust and Corporate party type in UK environment'

-- Check if this script has already run
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGuid = @ScriptGUID) 
    RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
BEGIN TRY

    SELECT @StartTranCount = @@TRANCOUNT

    IF (@StartTranCount = 0)
    BEGIN TRANSACTION 		

		SET IDENTITY_INSERT [TRefData] ON
 
		INSERT INTO [TRefData]([RefDataId],[Name],[Type],[Property],[RegionCode],[Attributes])
		VALUES  
				(105, 'Periodical Payment', 'income', 'category', 'GB', '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"53\"}')			
				
        SET IDENTITY_INSERT [TRefData] OFF
 
        -- Record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
        VALUES (@ScriptGUID, @Comments)
 
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