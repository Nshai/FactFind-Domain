 
-----------------------------------------------------------------------------
-- Table: CRM.TCampaign
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '0473AE7C-EBE9-46ED-A695-225ECCBE5A4A'
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
        SET IDENTITY_INSERT TCampaign ON; 
 
        INSERT INTO TCampaign([CampaignId], [CampaignTypeId], [IndigoClientId], [GroupId], [CampaignName], [ArchiveFG], [IsOrganisational], [ConcurrencyId])
        SELECT 5371,4210,466,NULL, 'Other',0,1,1 UNION ALL 
        SELECT 5372,4211,466,NULL, 'Other',0,1,1 UNION ALL 
        SELECT 5373,4212,466,NULL, 'Other',0,1,1 UNION ALL 
        SELECT 5374,4213,466,NULL, 'Other',0,1,1 UNION ALL 
        SELECT 5375,4214,466,NULL, 'Other',0,1,1 UNION ALL 
        SELECT 5376,4215,466,NULL, 'Other',0,1,1 UNION ALL 
        SELECT 5377,4216,466,NULL, 'Introducer',0,1,1 UNION ALL 
        SELECT 5378,4216,466,NULL, 'Lead',0,1,1 UNION ALL 
        SELECT 5379,4216,466,NULL, 'Other',0,1,1 UNION ALL 
        SELECT 5380,4217,466,NULL, 'Other',0,1,1 UNION ALL 
        SELECT 5381,4218,466,NULL, 'Other',0,1,1 UNION ALL 
        SELECT 5382,4219,466,NULL, 'Other',0,1,1 UNION ALL 
        SELECT 5383,4220,466,NULL, 'Other',0,1,1 
 
        SET IDENTITY_INSERT TCampaign OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '0473AE7C-EBE9-46ED-A695-225ECCBE5A4A', 
         'Initial load (13 total rows, file 1 of 1) for table TCampaign',
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
-- #Rows Exported: 13
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
