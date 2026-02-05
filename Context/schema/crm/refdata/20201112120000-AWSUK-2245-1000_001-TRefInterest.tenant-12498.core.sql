 
-----------------------------------------------------------------------------
-- Table: CRM.TRefInterest
--    Join: 
--   Where: WHERE IndigoClientId = 12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '4623A6E5-67EF-45C9-90B2-869179A7B7B3'
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
        SET IDENTITY_INSERT TRefInterest ON; 
 
        INSERT INTO TRefInterest([RefInterestId], [Descriptor], [Interest], [OpportunityTypeId], [OpportunityCreationFg], [Probability], [LeadVersionFG], [IndigoClientId], [ConcurrencyId], [ArchiveFG], [Ordinal], [SystemFG], [DefaultFG])
        SELECT 66204, 'Protection', 'Not Interested',NULL,0,0.00,0,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66205, 'Investments', 'Just Interested',NULL,0,0.00,1,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66206, 'Investments', 'Immediate Need',NULL,0,0.00,1,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66207, 'Pensions', 'Not Asked',NULL,0,0.00,0,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66208, 'Pensions', 'Not Interested',NULL,0,0.00,0,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66209, 'Pensions', 'Just Interested',NULL,0,0.00,1,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66210, 'Pensions', 'Immediate Need',NULL,0,0.00,1,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66211, 'General Insurance', 'Not Asked',NULL,0,0.00,0,12498,2,0,1,0,1 UNION ALL 
        SELECT 66213, 'Mortgage', 'Immediate Need',NULL,0,0.00,1,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66214, 'Mortgage', 'Just Interested',NULL,0,0.00,1,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66215, 'Mortgage', 'Not Interested',NULL,0,0.00,0,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66216, 'Mortgage', 'Not Asked',NULL,0,0.00,0,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66250, 'General Insurance', 'Yes',NULL,0,0.00,0,12498,1,0,2,0,0 UNION ALL 
        SELECT 66251, 'General Insurance', 'No',NULL,0,0.00,0,12498,1,0,3,0,0 UNION ALL 
        SELECT 66197, 'Investments', 'Not Interested',NULL,0,0.00,0,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66198, 'Investments', 'Not Asked',NULL,0,0.00,0,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66199, 'Protection', 'Immediate Need',NULL,0,0.00,1,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66200, 'Protection', 'Just Interested',NULL,0,0.00,1,12498,1,0,NULL,0,0 UNION ALL 
        SELECT 66203, 'Protection', 'Not Asked',NULL,0,0.00,0,12498,1,0,NULL,0,0 
 
        SET IDENTITY_INSERT TRefInterest OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '4623A6E5-67EF-45C9-90B2-869179A7B7B3', 
         'Initial load (19 total rows, file 1 of 1) for table TRefInterest',
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
-- #Rows Exported: 19
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
