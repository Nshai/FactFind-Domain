 
-----------------------------------------------------------------------------
-- Table: CRM.TOpportunityType
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'C3D4BBDA-3F07-4D3A-A597-3C2E37AAE8A2'
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
        SET IDENTITY_INSERT TOpportunityType ON; 
 
        INSERT INTO TOpportunityType([OpportunityTypeId], [OpportunityTypeName], [IndigoClientId], [ArchiveFG], [SystemFG], [InvestmentDefault], [RetirementDefault], [ConcurrencyId], [ObjectiveType])
        SELECT 34088, 'Advice - New',12498,0,0,0,0,1, NULL UNION ALL 
        SELECT 34089, 'Advice - Client Review',12498,0,0,0,0,1, NULL 
 
        SET IDENTITY_INSERT TOpportunityType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'C3D4BBDA-3F07-4D3A-A597-3C2E37AAE8A2', 
         'Initial load (2 total rows, file 1 of 1) for table TOpportunityType',
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
-- #Rows Exported: 7
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
