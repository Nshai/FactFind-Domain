 
-----------------------------------------------------------------------------
-- Table: CRM.TLeadStatus
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '4F125603-9C0D-4BC6-8116-3113438D909C'
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
        SET IDENTITY_INSERT TLeadStatus ON; 
 
        INSERT INTO TLeadStatus([LeadStatusId], [Descriptor], [CanConvertToClientFG], [OrderNumber], [IndigoClientId], [ConcurrencyId], [RefServiceStatusId])
        SELECT 14746, 'Initial',0,1,12498,1,NULL UNION ALL 
        SELECT 14747, 'Deferred',0,2,12498,1,NULL UNION ALL 
        SELECT 14748, 'Qualified',1,3,12498,2,34845 UNION ALL 
        SELECT 14749, 'Closed',0,4,12498,1,NULL 
 
        SET IDENTITY_INSERT TLeadStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '4F125603-9C0D-4BC6-8116-3113438D909C', 
         'Initial load (4 total rows, file 1 of 1) for table TLeadStatus',
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
-- #Rows Exported: 4
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
