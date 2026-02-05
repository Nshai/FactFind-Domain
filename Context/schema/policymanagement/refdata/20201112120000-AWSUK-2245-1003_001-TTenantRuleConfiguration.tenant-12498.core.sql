 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TTenantRuleConfiguration
--    Join: 
--   Where: WHERE TenantId=12498
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '415E89E6-B405-47FF-AE78-D60A7F3571B5'
     AND TenantId = 12498
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
        SELECT 61292,1,0,12498,1 UNION ALL 
        SELECT 61295,4,0,12498,1 UNION ALL 
        SELECT 61297,6,0,12498,1 UNION ALL 
        SELECT 61298,7,0,12498,1 UNION ALL 
        SELECT 61299,8,0,12498,1 UNION ALL 
        SELECT 61301,10,0,12498,1 UNION ALL 
        SELECT 61302,11,0,12498,1 UNION ALL 
        SELECT 61304,13,0,12498,1 UNION ALL 
        SELECT 61305,14,0,12498,1 UNION ALL 
        SELECT 61306,15,0,12498,1 UNION ALL 
        SELECT 61308,17,0,12498,1 UNION ALL 
        SELECT 61309,18,0,12498,1 UNION ALL 
        SELECT 61293,2,1,12498,1 UNION ALL 
        SELECT 61294,3,1,12498,1 UNION ALL 
        SELECT 61296,5,1,12498,1 UNION ALL 
        SELECT 61300,9,1,12498,1 UNION ALL 
        SELECT 61303,12,1,12498,1 UNION ALL 
        SELECT 61307,16,1,12498,1 
 
        SET IDENTITY_INSERT TTenantRuleConfiguration OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '415E89E6-B405-47FF-AE78-D60A7F3571B5', 
         'Initial load (18 total rows, file 1 of 1) for table TTenantRuleConfiguration',
         12498, 
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
