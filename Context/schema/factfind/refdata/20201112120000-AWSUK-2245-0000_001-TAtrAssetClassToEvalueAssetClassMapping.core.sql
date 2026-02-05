 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrAssetClassToEvalueAssetClassMapping
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '13761426-623C-4CE3-8E41-1DBB724A9D61'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAtrAssetClassToEvalueAssetClassMapping ON; 
 
        INSERT INTO TAtrAssetClassToEvalueAssetClassMapping([AtrAssetClassToEvalueAssetClassMappingId], [RefEvalueAssetClassId], [AtrRefAssetClassId], [ConcurrencyId])
        SELECT 1,2,1,1 UNION ALL 
        SELECT 2,10,2,1 UNION ALL 
        SELECT 3,1,38,1 UNION ALL 
        SELECT 4,3,39,1 UNION ALL 
        SELECT 5,4,40,1 UNION ALL 
        SELECT 6,5,41,1 UNION ALL 
        SELECT 7,6,42,1 UNION ALL 
        SELECT 8,7,43,1 UNION ALL 
        SELECT 9,8,44,1 UNION ALL 
        SELECT 10,9,45,1 UNION ALL 
        SELECT 11,11,46,1 UNION ALL 
        SELECT 12,12,47,1 
 
        SET IDENTITY_INSERT TAtrAssetClassToEvalueAssetClassMapping OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '13761426-623C-4CE3-8E41-1DBB724A9D61', 
         'Initial load (12 total rows, file 1 of 1) for table TAtrAssetClassToEvalueAssetClassMapping',
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
