 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefSchemeBasis
--    Join: 
--   Where: WHERE IndigoClientId IS NULL
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '44C586CB-87F5-47A7-8BA9-AA04240605A8'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefSchemeBasis ON; 
 
        INSERT INTO TRefSchemeBasis([RefSchemeBasisId], [Descriptor], [ArchiveFG], [DPMapping], [IndigoClientId], [ConcurrencyId])
        SELECT 1, '30ths',0, NULL,NULL,2 UNION ALL 
        SELECT 2, '35ths',0, NULL,NULL,2 UNION ALL 
        SELECT 3, '40ths',0, NULL,NULL,2 UNION ALL 
        SELECT 4, '45ths',0, NULL,NULL,2 UNION ALL 
        SELECT 5, '50ths',0, NULL,NULL,2 UNION ALL 
        SELECT 6, '55ths',0, NULL,NULL,2 UNION ALL 
        SELECT 7, '60ths',0, NULL,NULL,2 UNION ALL 
        SELECT 8, '65ths',0, NULL,NULL,2 UNION ALL 
        SELECT 9, '70ths',0, NULL,NULL,2 UNION ALL 
        SELECT 10, '75ths',0, NULL,NULL,2 UNION ALL 
        SELECT 11, '80ths',0, NULL,NULL,2 UNION ALL 
        SELECT 12, '85ths',0, NULL,NULL,2 UNION ALL 
        SELECT 13, '90ths',0, NULL,NULL,2 UNION ALL 
        SELECT 14, '95ths',0, NULL,NULL,2 UNION ALL 
        SELECT 15, '100ths',0, NULL,NULL,2 UNION ALL 
        SELECT 16, '105ths',0, NULL,NULL,2 UNION ALL 
        SELECT 17, '110ths',0, NULL,NULL,2 UNION ALL 
        SELECT 18, '115ths',0, NULL,NULL,2 UNION ALL 
        SELECT 19, '120ths',0, NULL,NULL,2 
 
        SET IDENTITY_INSERT TRefSchemeBasis OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '44C586CB-87F5-47A7-8BA9-AA04240605A8', 
         'Initial load (19 total rows, file 1 of 1) for table TRefSchemeBasis',
         null, 
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
