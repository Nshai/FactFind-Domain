 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TSchemePlanType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '2FB78D1B-F6DE-484E-917B-D13354D1D5B3'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TSchemePlanType ON; 
 
        INSERT INTO TSchemePlanType([SchemePlanTypeId], [SchemeTypeId], [RefPlanType2ProdSubTypeId], [ConcurrencyId], [RefLicenceTypeId])
        SELECT 338,4,147,1,1 UNION ALL 
        SELECT 337,5,1052,1,1 UNION ALL 
        SELECT 336,1,11,1,1 UNION ALL 
        SELECT 335,1,1038,1,1 UNION ALL 
        SELECT 334,5,1037,1,1 UNION ALL 
        SELECT 23,5,1016,1,1 UNION ALL 
        SELECT 22,5,144,1,1 UNION ALL 
        SELECT 21,10,78,1,1 UNION ALL 
        SELECT 20,5,65,1,1 UNION ALL 
        SELECT 18,4,126,1,1 UNION ALL 
        SELECT 17,4,115,1,1 UNION ALL 
        SELECT 16,4,63,1,1 UNION ALL 
        SELECT 15,3,64,1,1 UNION ALL 
        SELECT 14,2,109,1,1 UNION ALL 
        SELECT 13,2,24,1,1 UNION ALL 
        SELECT 12,2,23,1,1 UNION ALL 
        SELECT 11,1,1006,1,1 UNION ALL 
        SELECT 10,1,132,1,1 UNION ALL 
        SELECT 9,1,131,1,1 UNION ALL 
        SELECT 8,1,130,1,1 UNION ALL 
        SELECT 7,1,129,1,1 UNION ALL 
        SELECT 6,1,21,1,1 UNION ALL 
        SELECT 5,1,20,1,1 UNION ALL 
        SELECT 4,1,19,1,1 UNION ALL 
        SELECT 3,1,18,1,1 UNION ALL 
        SELECT 2,1,17,1,1 UNION ALL 
        SELECT 1,1,15,1,1 UNION ALL 
        SELECT 339,9,1094,1,1 UNION ALL 
        SELECT 340,4,146,1,1 UNION ALL 
        SELECT 341,8,146,1,2 UNION ALL 
        SELECT 342,1,1105,1,1 UNION ALL 
        SELECT 343,1,1109,1,1 UNION ALL 
        SELECT 344,1,12,1,1 UNION ALL 
        SELECT 345,2,1114,1,1 UNION ALL 
        SELECT 346,2,1115,1,1 UNION ALL 
        SELECT 347,1,1128,1,1 UNION ALL 
        SELECT 379,4,146,1,2 UNION ALL 
        SELECT 375,5,1094,1,1 
 
        SET IDENTITY_INSERT TSchemePlanType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '2FB78D1B-F6DE-484E-917B-D13354D1D5B3', 
         'Initial load (38 total rows, file 1 of 1) for table TSchemePlanType',
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
-- #Rows Exported: 38
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
