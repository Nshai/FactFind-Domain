 
-----------------------------------------------------------------------------
-- Table: CRM.TRefInterest
--    Join: 
--   Where: WHERE IndigoClientId = 466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '4623A6E5-67EF-45C9-90B2-869179A7B7B3'
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
        SET IDENTITY_INSERT TRefInterest ON; 
 
        INSERT INTO TRefInterest([RefInterestId], [Descriptor], [Interest], [OpportunityTypeId], [OpportunityCreationFg], [Probability], [LeadVersionFG], [IndigoClientId], [ConcurrencyId], [ArchiveFG], [Ordinal], [SystemFG], [DefaultFG])
        SELECT 24684, 'General Insurance', 'Not Asked',NULL,0,0.00,0,466,1,0,3,1,1 UNION ALL 
        SELECT 24685, 'General Insurance', 'Not Interested',NULL,0,0.00,0,466,1,0,4,1,0 UNION ALL 
        SELECT 24686, 'General Insurance', 'Just Interested',NULL,0,0.00,1,466,1,0,2,1,0 UNION ALL 
        SELECT 24687, 'General Insurance', 'Immediate Need',NULL,0,0.00,1,466,1,0,1,1,0 UNION ALL 
        SELECT 5089, 'Mortgage', 'Not Asked',NULL,0,0.00,0,466,1,0,3,1,1 UNION ALL 
        SELECT 5090, 'Mortgage', 'Not Interested',NULL,0,0.00,0,466,1,0,4,1,0 UNION ALL 
        SELECT 5091, 'Mortgage', 'Just Interested',NULL,0,0.00,1,466,1,0,2,1,0 UNION ALL 
        SELECT 5092, 'Mortgage', 'Immediate Need',NULL,0,0.00,1,466,1,0,1,1,0 UNION ALL 
        SELECT 5093, 'Pensions', 'Not Asked',NULL,0,0.00,0,466,1,0,3,1,1 UNION ALL 
        SELECT 5094, 'Pensions', 'Not Interested',NULL,0,0.00,0,466,1,0,4,1,0 UNION ALL 
        SELECT 5095, 'Pensions', 'Just Interested',NULL,0,0.00,1,466,1,0,2,1,0 UNION ALL 
        SELECT 5096, 'Pensions', 'Immediate Need',NULL,0,0.00,1,466,1,0,1,1,0 UNION ALL 
        SELECT 5097, 'Protection', 'Not Asked',NULL,0,0.00,0,466,1,0,3,1,1 UNION ALL 
        SELECT 5098, 'Protection', 'Not Interested',NULL,0,0.00,0,466,1,0,4,1,0 UNION ALL 
        SELECT 5099, 'Protection', 'Just Interested',NULL,0,0.00,1,466,1,0,2,1,0 UNION ALL 
        SELECT 5100, 'Protection', 'Immediate Need',NULL,0,0.00,1,466,1,0,1,1,0 UNION ALL 
        SELECT 5101, 'Investments', 'Not Asked',NULL,0,0.00,0,466,1,0,3,1,1 UNION ALL 
        SELECT 5102, 'Investments', 'Not Interested',NULL,0,0.00,0,466,1,0,4,1,0 UNION ALL 
        SELECT 5103, 'Investments', 'Just Interested',NULL,0,0.00,1,466,1,0,2,1,0 UNION ALL 
        SELECT 5104, 'Investments', 'Immediate Need',NULL,0,0.00,1,466,1,0,1,1,0 
 
        SET IDENTITY_INSERT TRefInterest OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '4623A6E5-67EF-45C9-90B2-869179A7B7B3', 
         'Initial load (20 total rows, file 1 of 1) for table TRefInterest',
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
-- #Rows Exported: 20
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
