 
-----------------------------------------------------------------------------
-- Table: CRM.TRefShowTimeAs
--    Join: 
--   Where: WHERE IndClientId=12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '8E3D3259-C9ED-4453-83D8-A9D82F0247A7'
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
        SET IDENTITY_INSERT TRefShowTimeAs ON; 
 
        INSERT INTO TRefShowTimeAs([RefShowTimeAsId], [Description], [Color], [FreeFG], [IndClientId], [Extensible], [ConcurrencyId])
        SELECT 13398, 'Free', '',0,12498,NULL,1 UNION ALL 
        SELECT 13399, 'Tentative', '',0,12498,NULL,1 UNION ALL 
        SELECT 13400, 'Free', '',0,12498,NULL,1 UNION ALL 
        SELECT 13401, 'Tentative', '',0,12498,NULL,1 
 
        SET IDENTITY_INSERT TRefShowTimeAs OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '8E3D3259-C9ED-4453-83D8-A9D82F0247A7', 
         'Initial load (4 total rows, file 1 of 1) for table TRefShowTimeAs',
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
