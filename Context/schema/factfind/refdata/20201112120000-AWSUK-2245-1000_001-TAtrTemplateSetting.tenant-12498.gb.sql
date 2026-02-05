 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrTemplateSetting
--    Join: join TAtrTemplate t on t.AtrTemplateId = TAtrTemplateSetting.AtrTemplateId
--   Where: WHERE t.IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '431C6581-438C-4A85-A717-6C15DB6FE0C1'
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
        SET IDENTITY_INSERT TAtrTemplateSetting ON; 
 
        INSERT INTO TAtrTemplateSetting([AtrTemplateSettingId], [AtrTemplateId], [AtrRefProfilePreferenceId], [OverrideProfile], [LossAndGain], [AssetAllocation], [CostOfDelay], [Report], [AutoCreateOpportunities], [ConcurrencyId], [ReportLabel])
        SELECT 9132,9140,1,1,1,1,1,1,1,1, NULL 
 
        SET IDENTITY_INSERT TAtrTemplateSetting OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '431C6581-438C-4A85-A717-6C15DB6FE0C1', 
         'Initial load (1 total rows, file 1 of 1) for table TAtrTemplateSetting',
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
-- #Rows Exported: 1
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
