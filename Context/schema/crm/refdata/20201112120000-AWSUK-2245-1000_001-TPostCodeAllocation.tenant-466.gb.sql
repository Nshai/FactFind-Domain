 
-----------------------------------------------------------------------------
-- Table: CRM.TPostCodeAllocation
--    Join: 
--   Where: WHERE IndigoClientId = 466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '1602BDE2-1FEE-4387-A65B-3D3A7C7F754F'
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
        SET IDENTITY_INSERT TPostCodeAllocation ON; 
 
        INSERT INTO TPostCodeAllocation([PostCodeAllocationId], [IndigoClientId], [MaxDistance], [AllocationTypeId], [ConcurrencyId], [SecondaryAllocationTypeId], [CanAssignPostCodeMoreThanOne], [CanAssignAdviserMoreThanOne])
        SELECT 362,466,50,1,1,NULL,NULL,NULL 
 
        SET IDENTITY_INSERT TPostCodeAllocation OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '1602BDE2-1FEE-4387-A65B-3D3A7C7F754F', 
         'Initial load (1 total rows, file 1 of 1) for table TPostCodeAllocation',
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
-- #Rows Exported: 1
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
