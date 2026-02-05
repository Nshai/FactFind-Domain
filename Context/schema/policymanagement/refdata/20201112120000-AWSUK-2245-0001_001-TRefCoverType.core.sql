 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefCoverType
--    Join: 
--   Where: WHERE IndigoClientId IS NULL
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'C2071D57-091D-4E21-8B6A-434B5211D31A'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefCoverType ON; 
 
        INSERT INTO TRefCoverType([RefCoverTypeId], [Descriptor], [ArchiveFG], [IndigoClientId], [ConcurrencyId])
        SELECT 1, 'Home',1,NULL,1 UNION ALL 
        SELECT 2, 'Contents',1,NULL,1 UNION ALL 
        SELECT 3, 'Home and Contents',1,NULL,1 UNION ALL 
        SELECT 4, 'Car',1,NULL,1 UNION ALL 
        SELECT 5, 'Invest. or Bus. Property',1,NULL,1 UNION ALL 
        SELECT 6, 'Other',1,NULL,1 
 
        SET IDENTITY_INSERT TRefCoverType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'C2071D57-091D-4E21-8B6A-434B5211D31A', 
         'Initial load (6 total rows, file 1 of 1) for table TRefCoverType',
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
-- #Rows Exported: 6
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
