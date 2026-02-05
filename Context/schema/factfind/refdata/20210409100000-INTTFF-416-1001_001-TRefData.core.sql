----------------------------------------------------------------------------------------
--
-- Summary: INTTFF-416 SQL - Add additional Income category reference data for Australia
--
----------------------------------------------------------------------------------------

USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER = 'A09F04AC-43D1-48AB-B04E-FAC93DB269B0'
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

		SET IDENTITY_INSERT [TRefData] ON
 
		INSERT INTO [TRefData]([RefDataId],[Name],[Type],[Property],[RegionCode],[Attributes])
		VALUES  
				(97, 'Bonus (Guaranteed)', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'),
				(98, 'Bonus (Regular)', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}')				
				
        SET IDENTITY_INSERT [TRefData] OFF
 
        -- Record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
        VALUES (@ScriptGUID, 'Update Income category ref data based for Australia')
 
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