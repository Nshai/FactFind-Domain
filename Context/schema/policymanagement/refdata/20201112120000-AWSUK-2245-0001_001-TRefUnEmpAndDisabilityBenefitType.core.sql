 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefUnEmpAndDisabilityBenefitType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '9C338EB7-75EA-4E7A-987F-BB4C6DD114C1'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefUnEmpAndDisabilityBenefitType ON; 
 
        INSERT INTO TRefUnEmpAndDisabilityBenefitType([RefUnEmpAndDisabilityBenefitTypeId], [Name], [ConcurrencyId])
        SELECT 1, 'None',1 UNION ALL 
        SELECT 2, 'Excess',1 UNION ALL 
        SELECT 3, 'DayOne',1 
 
        SET IDENTITY_INSERT TRefUnEmpAndDisabilityBenefitType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '9C338EB7-75EA-4E7A-987F-BB4C6DD114C1', 
         'Initial load (3 total rows, file 1 of 1) for table TRefUnEmpAndDisabilityBenefitType',
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
