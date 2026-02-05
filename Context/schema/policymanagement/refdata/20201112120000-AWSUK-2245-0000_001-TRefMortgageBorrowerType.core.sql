 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefMortgageBorrowerType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '53F09443-9D54-487C-A7E7-746432A5AACA'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefMortgageBorrowerType ON; 
 
        INSERT INTO TRefMortgageBorrowerType([RefMortgageBorrowerTypeId], [MortgageBorrowerType], [ConcurrencyId])
        SELECT 1, 'First time buyer',1 UNION ALL 
        SELECT 2, 'Home Mover',1 UNION ALL 
        SELECT 3, 'Remortgage',1 UNION ALL 
        SELECT 4, 'Council/Tenant To Buy',1 UNION ALL 
        SELECT 5, 'Bridging Loan',1 UNION ALL 
        SELECT 6, 'Buy To Let',1 UNION ALL 
        SELECT 7, 'Let To Buy',1 UNION ALL 
        SELECT 8, 'Right To Buy',1 UNION ALL 
        SELECT 9, 'Self-Build',1 UNION ALL 
        SELECT 10, 'Shared Ownership',1 UNION ALL 
        SELECT 11, 'Islamic',1 UNION ALL 
        SELECT 12, 'Holiday Home',1 UNION ALL 
        SELECT 13, 'Further Advance',1 
 
        SET IDENTITY_INSERT TRefMortgageBorrowerType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '53F09443-9D54-487C-A7E7-746432A5AACA', 
         'Initial load (13 total rows, file 1 of 1) for table TRefMortgageBorrowerType',
         null, 
         getdate() )
 
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
-----------------------------------------------------------------------------
-- #Rows Exported: 13
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
