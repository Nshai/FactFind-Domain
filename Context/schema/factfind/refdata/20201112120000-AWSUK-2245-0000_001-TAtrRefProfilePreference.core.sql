 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrRefProfilePreference
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '167955B7-A953-4F4D-9DBB-66FF80EC88FE'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAtrRefProfilePreference ON; 
 
        INSERT INTO TAtrRefProfilePreference([AtrRefProfilePreferenceId], [Identifier], [Descriptor], [ConcurrencyId])
        SELECT 2, 'Investment & Retirement', 'Risk profile questions appear independently for both Investment and Retirement',1 UNION ALL 
        SELECT 1, 'Client Profile', 'Risk profile questions appear once in the client profile',1 
 
        SET IDENTITY_INSERT TAtrRefProfilePreference OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '167955B7-A953-4F4D-9DBB-66FF80EC88FE', 
         'Initial load (2 total rows, file 1 of 1) for table TAtrRefProfilePreference',
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
-- #Rows Exported: 2
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
