 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefAdviseFeeType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'DCB63F15-22EC-4D7B-BB8A-20DA29392625'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefAdviseFeeType ON; 
 
        INSERT INTO TRefAdviseFeeType([RefAdviseFeeTypeId], [Name], [IsInitial], [IsOneOff], [IsRecurring])
        SELECT 1, 'Initial Fee',1,0,0 UNION ALL 
        SELECT 2, 'On-going Fee',0,0,1 UNION ALL 
        SELECT 3, 'Ad-hoc Fee',0,1,0 
 
        SET IDENTITY_INSERT TRefAdviseFeeType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'DCB63F15-22EC-4D7B-BB8A-20DA29392625', 
         'Initial load (3 total rows, file 1 of 1) for table TRefAdviseFeeType',
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
