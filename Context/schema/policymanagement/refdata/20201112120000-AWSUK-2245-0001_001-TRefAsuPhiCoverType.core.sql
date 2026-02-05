 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefAsuPhiCoverType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'D35B462C-94FB-489B-8D9F-2AC221088CDD'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefAsuPhiCoverType ON; 
 
        INSERT INTO TRefAsuPhiCoverType([RefAsuPhiCoverTypeId], [Name], [ConcurrencyId])
        SELECT 1, 'UnemploymentAndDisability',1 UNION ALL 
        SELECT 2, 'Disability',1 UNION ALL 
        SELECT 3, 'Unemployment',1 
 
        SET IDENTITY_INSERT TRefAsuPhiCoverType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'D35B462C-94FB-489B-8D9F-2AC221088CDD', 
         'Initial load (3 total rows, file 1 of 1) for table TRefAsuPhiCoverType',
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
-- #Rows Exported: 3
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
