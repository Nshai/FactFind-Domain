 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TTenantRuleConfiguration
--    Join: 
--   Where: WHERE TenantId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '415E89E6-B405-47FF-AE78-D60A7F3571B5'
     AND TenantId = 466
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TTenantRuleConfiguration ON; 
 
        INSERT INTO TTenantRuleConfiguration([TenantRuleConfigurationId], [RefRuleConfigurationId], [IsConfigured], [TenantId], [ConcurrencyId])
        SELECT 321,1,0,466,1 UNION ALL 
        SELECT 1823,2,0,466,1 UNION ALL 
        SELECT 3459,3,0,466,1 UNION ALL 
        SELECT 4942,4,0,466,1 UNION ALL 
        SELECT 6794,5,0,466,1 UNION ALL 
        SELECT 8672,6,0,466,1 UNION ALL 
        SELECT 11566,7,0,466,1 UNION ALL 
        SELECT 12118,8,0,466,1 UNION ALL 
        SELECT 16117,10,0,466,1 UNION ALL 
        SELECT 17872,11,0,466,1 UNION ALL 
        SELECT 21382,13,0,466,1 UNION ALL 
        SELECT 23475,14,0,466,1 UNION ALL 
        SELECT 25256,15,0,466,1 UNION ALL 
        SELECT 31284,17,0,466,1 UNION ALL 
        SELECT 33219,18,0,466,1 UNION ALL 
        SELECT 13682,9,1,466,1 UNION ALL 
        SELECT 19627,12,1,466,1 UNION ALL 
        SELECT 27997,16,1,466,1 
 
        SET IDENTITY_INSERT TTenantRuleConfiguration OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '415E89E6-B405-47FF-AE78-D60A7F3571B5', 
         'Initial load (18 total rows, file 1 of 1) for table TTenantRuleConfiguration',
         466, 
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
-- #Rows Exported: 18
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
