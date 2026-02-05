 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefAdditionalPropertyDetail
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'D8845561-859B-44EE-9D98-83C813C88688'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefAdditionalPropertyDetail ON; 
 
        INSERT INTO TRefAdditionalPropertyDetail([RefAdditionalPropertyDetailId], [Description], [ConcurrencyId])
        SELECT 1, 'Conversion',1 UNION ALL 
        SELECT 2, 'End Terrace',1 UNION ALL 
        SELECT 3, 'Flat over four storeys',1 UNION ALL 
        SELECT 4, 'Listed Building',1 UNION ALL 
        SELECT 5, 'Mid Terrace',1 UNION ALL 
        SELECT 6, 'Over a shop',1 UNION ALL 
        SELECT 7, 'Purpose Built',1 
 
        SET IDENTITY_INSERT TRefAdditionalPropertyDetail OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'D8845561-859B-44EE-9D98-83C813C88688', 
         'Initial load (7 total rows, file 1 of 1) for table TRefAdditionalPropertyDetail',
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
-- #Rows Exported: 7
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
