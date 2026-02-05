 
-----------------------------------------------------------------------------
-- Table: CRM.TRefTrustType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '00D33527-01C5-477E-B4B7-B67A2D338BA6'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefTrustType ON; 
 
        INSERT INTO TRefTrustType([RefTrustTypeId], [TrustTypeName], [ArchiveFG], [Extensible], [ConcurrencyId])
        SELECT 5, 'Bare',0,NULL,1 UNION ALL 
        SELECT 4, 'Interest in Possession',0,NULL,1 UNION ALL 
        SELECT 3, 'Discretionary',0,NULL,1 UNION ALL 
        SELECT 2, 'Accumulation and Maintenance',0,NULL,1 UNION ALL 
        SELECT 1, 'Other',0,NULL,1 
 
        SET IDENTITY_INSERT TRefTrustType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '00D33527-01C5-477E-B4B7-B67A2D338BA6', 
         'Initial load (5 total rows, file 1 of 1) for table TRefTrustType',
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
