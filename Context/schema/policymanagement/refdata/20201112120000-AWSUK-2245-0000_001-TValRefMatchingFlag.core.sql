 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValRefMatchingFlag
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '729048BA-3EBD-40B1-8442-E4B34012A486'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValRefMatchingFlag ON; 
 
        INSERT INTO TValRefMatchingFlag([ValRefMatchingFlagId], [MatchingFlag], [MatchingDescription], [ConcurrencyId])
        SELECT 1,1, 'Clean up leading zeros from plan number',1 UNION ALL 
        SELECT 2,2, 'Clean up space from plan number',1 UNION ALL 
        SELECT 3,4, 'Unused - Format plan number for tax year fidelity isa and pep plans',2 UNION ALL 
        SELECT 4,16, 'Default - Match plan number with portfolio reference',2 UNION ALL 
        SELECT 5,32, 'Unused - Match plan number with customer reference',2 UNION ALL 
        SELECT 6,64, 'Extended - Match portal reference with portfolio type',2 UNION ALL 
        SELECT 7,128, 'Unused - Match portal reference with customer reference',2 UNION ALL 
        SELECT 8,256, 'Unused - Match wrapper plan number with customer reference',3 UNION ALL 
        SELECT 9,512, 'Unused - Match agency number with adviser reference',2 UNION ALL 
        SELECT 10,1024, 'Extended - Match additional cofund rules',2 UNION ALL 
        SELECT 11,2048, 'Extended - Match additional IO template rules',2 UNION ALL 
        SELECT 12,16384, 'Update Portfolio Reference',1 UNION ALL 
        SELECT 13,32768, 'Update Portal Reference',1 UNION ALL 
        SELECT 14,65536, 'update dfm and modelportfolio flag',1 
 
        SET IDENTITY_INSERT TValRefMatchingFlag OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '729048BA-3EBD-40B1-8442-E4B34012A486', 
         'Initial load (14 total rows, file 1 of 1) for table TValRefMatchingFlag',
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
-- #Rows Exported: 14
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
