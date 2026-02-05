 
-----------------------------------------------------------------------------
-- Table: CRM.TCampaignType
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '0A1A8E77-4EB3-4FDB-84E9-23613C1DC4B7'
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
        SET IDENTITY_INSERT TCampaignType ON; 
 
        INSERT INTO TCampaignType([CampaignTypeId], [IndigoClientId], [CampaignType], [ArchiveFG], [ConcurrencyId])
        SELECT 4210,466, 'Mailshot',0,1 UNION ALL 
        SELECT 4211,466, 'Referral',0,1 UNION ALL 
        SELECT 4212,466, 'Known to Practitioner',0,1 UNION ALL 
        SELECT 4213,466, 'Existing Client',0,1 UNION ALL 
        SELECT 4214,466, 'Client Approach',0,1 UNION ALL 
        SELECT 4215,466, 'Seminar/Exhibition',0,1 UNION ALL 
        SELECT 4216,466, 'Recommendation',0,1 UNION ALL 
        SELECT 4217,466, 'Advertisement',0,1 UNION ALL 
        SELECT 4218,466, 'Web',0,1 UNION ALL 
        SELECT 4219,466, 'Newspaper',0,1 UNION ALL 
        SELECT 4220,466, 'Other',0,1 
 
        SET IDENTITY_INSERT TCampaignType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '0A1A8E77-4EB3-4FDB-84E9-23613C1DC4B7', 
         'Initial load (11 total rows, file 1 of 1) for table TCampaignType',
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
-- #Rows Exported: 11
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
