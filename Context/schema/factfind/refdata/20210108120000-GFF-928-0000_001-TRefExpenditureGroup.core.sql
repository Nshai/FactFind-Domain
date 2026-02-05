-----------------------------------------------------------------------------
-- Table: FactFind.TRefExpenditureGroup
-----------------------------------------------------------------------------
 
USE FactFind

DECLARE @ScriptId UNIQUEIDENTIFIER 
SET  @ScriptId = '01EE3F61-882E-40AF-A376-D5061134CC97'

-- Check that this script has not already been run
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGuid = @ScriptId) 
	RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int

BEGIN TRY
    
	SELECT @starttrancount = @@TRANCOUNT
    
	IF (@starttrancount = 0)
		BEGIN TRANSACTION


		-- Insert default Expenditure Groups for all existing active tenants
		INSERT INTO [factfind].[dbo].[TRefExpenditureGroup] 
				(TenantId, Name, Ordinal, IsConsolidateEnabled)
		SELECT a.IndigoClientId, e.Name, e.Ordinal, e.IsConsolidateEnabled
		FROM administration.dbo.TIndigoClient a
		CROSS JOIN factfind.dbo.TRefExpenditureGroup e
		where e.TenantId is null


    -- record execution so the script won't run again
    INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
    VALUES (@ScriptId, 'GFF-928 Create tenent specific default Expenditure groups', NULL, GETDATE() )
 
	IF (@starttrancount = 0)
		COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH
 
 SET XACT_ABORT OFF
 SET NOCOUNT OFF

