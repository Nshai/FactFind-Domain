 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefEvalueAssetClass
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'C2B6BF7F-748F-4DD0-AA9A-8DC693D43AA6'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefEvalueAssetClass ON; 
 
        INSERT INTO TRefEvalueAssetClass([RefEvalueAssetClassId], [Identifier], [ConcurrencyId])
        SELECT 1, 'Asia_ex_Japan_Equity',1 UNION ALL 
        SELECT 2, 'Cash',1 UNION ALL 
        SELECT 3, 'Corporate_Bonds_High_Yield',1 UNION ALL 
        SELECT 4, 'Corporate_Bonds_Inv_Grade',1 UNION ALL 
        SELECT 5, 'Europe_Equity',1 UNION ALL 
        SELECT 6, 'Global_Emerging_Market_Equity',1 UNION ALL 
        SELECT 7, 'Government_Bonds',1 UNION ALL 
        SELECT 8, 'Index_Linked_Bonds',1 UNION ALL 
        SELECT 9, 'Japan_Equity',1 UNION ALL 
        SELECT 10, 'Property',1 UNION ALL 
        SELECT 11, 'UK_Equity',1 UNION ALL 
        SELECT 12, 'US_Equity',1 
 
        SET IDENTITY_INSERT TRefEvalueAssetClass OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'C2B6BF7F-748F-4DD0-AA9A-8DC693D43AA6', 
         'Initial load (12 total rows, file 1 of 1) for table TRefEvalueAssetClass',
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
-- #Rows Exported: 12
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
