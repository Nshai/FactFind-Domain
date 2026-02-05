 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefFrequency
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '08F2754D-0F23-4097-A4BF-5DF1533840D5'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFrequency ON; 
 
        INSERT INTO TRefFrequency([RefFrequencyId], [FrequencyName], [OrigoRef], [RetireFg], [OrderNo], [Extensible], [ConcurrencyId], [MultiplierForAnnualisedAmount])
        SELECT 1, 'Weekly', 'Frequency',0,2,NULL,1,52 UNION ALL 
        SELECT 2, 'Fortnightly', 'Frequency',0,3,NULL,1,26 UNION ALL 
        SELECT 3, 'Four Weekly', 'Frequency',0,4,NULL,1,13 UNION ALL 
        SELECT 4, 'Monthly', 'Frequency',0,1,NULL,1,12 UNION ALL 
        SELECT 5, 'Quarterly', 'Frequency',0,5,NULL,1,4 UNION ALL 
        SELECT 6, 'Termly', 'Frequency',1,6,NULL,1,3 UNION ALL 
        SELECT 7, 'Half Yearly', 'Frequency',0,7,NULL,1,2 UNION ALL 
        SELECT 8, 'Annually', 'Frequency',0,8,NULL,1,1 UNION ALL 
        SELECT 9, 'Single', 'Frequency',1,9,NULL,1,1 UNION ALL 
        SELECT 10, 'Single', 'Frequency',0,10,NULL,1,1 
 
        SET IDENTITY_INSERT TRefFrequency OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '08F2754D-0F23-4097-A4BF-5DF1533840D5', 
         'Initial load (10 total rows, file 1 of 1) for table TRefFrequency',
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
-- #Rows Exported: 10
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
