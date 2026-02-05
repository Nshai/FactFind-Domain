 
-----------------------------------------------------------------------------
-- Table: CRM.TCampaign
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '0473AE7C-EBE9-46ED-A695-225ECCBE5A4A'
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
        SET IDENTITY_INSERT TCampaign ON; 
 
        INSERT INTO TCampaign([CampaignId], [CampaignTypeId], [IndigoClientId], [GroupId], [CampaignName], [ArchiveFG], [IsOrganisational], [ConcurrencyId])
        SELECT 86048,45388,12498,NULL, 'Other',0,1,1 UNION ALL 
        SELECT 86050,45390,12498,NULL, 'Other',0,1,1 UNION ALL 
        SELECT 86059,45397,12498,NULL, 'Other',0,1,1 
 
        SET IDENTITY_INSERT TCampaign OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '0473AE7C-EBE9-46ED-A695-225ECCBE5A4A', 
         'Initial load (3 total rows, file 1 of 1) for table TCampaign',
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
-- #Rows Exported: 3
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
