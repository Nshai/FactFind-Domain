 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefTotalPlanValuationType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '1BF0030B-01C6-4CC8-BDC7-B91FA04E9D10'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefTotalPlanValuationType ON; 
 
        INSERT INTO TRefTotalPlanValuationType([RefTotalPlanValuationTypeId], [Description], [ShortDescription], [ConcurrencyId])
        SELECT 1, 'Total of Sub Plans, if any have a value, otherwise Total of Master Plan', 'TotalSubPlansIfHaveValueOrTotalMasterPlanValue',1 UNION ALL 
        SELECT 2, 'Total of Master Plan and Sub Plans', 'TotalMasterAndSubPlans',1 UNION ALL 
        SELECT 3, 'Total of Master Plan excluding Sub Plans', 'TotalMasterPlanExcludingSubPlans',1 
 
        SET IDENTITY_INSERT TRefTotalPlanValuationType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '1BF0030B-01C6-4CC8-BDC7-B91FA04E9D10', 
         'Initial load (3 total rows, file 1 of 1) for table TRefTotalPlanValuationType',
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
