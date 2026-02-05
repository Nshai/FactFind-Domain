 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefTotalPermanentDisabilityType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '59F7287D-9464-41EC-BC73-B8E74D93BCB7'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefTotalPermanentDisabilityType ON; 
 
        INSERT INTO TRefTotalPermanentDisabilityType([RefTotalPermanentDisabilityTypeId], [TypeName], [ConcurrencyId])
        SELECT 1, 'None',1 UNION ALL 
        SELECT 2, 'Own Occupation',1 UNION ALL 
        SELECT 3, 'Any Suited Occupation',1 UNION ALL 
        SELECT 4, 'Any Occupation',1 UNION ALL 
        SELECT 5, 'Insurer Best',1 UNION ALL 
        SELECT 6, 'Activities Of Daily Living',1 UNION ALL 
        SELECT 7, 'Work Tasks',1 
 
        SET IDENTITY_INSERT TRefTotalPermanentDisabilityType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '59F7287D-9464-41EC-BC73-B8E74D93BCB7', 
         'Initial load (7 total rows, file 1 of 1) for table TRefTotalPermanentDisabilityType',
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
-- #Rows Exported: 7
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
