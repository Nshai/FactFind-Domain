 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValScheduleConfig
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '509B1532-4E4A-46C4-8E2D-E4B7C328DD87'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValScheduleConfig ON; 
 
        INSERT INTO TValScheduleConfig([ValScheduleConfigId], [RefProdProviderId], [ScheduleStartTime], [IsEnabled], [ConcurrencyId])
        SELECT 1,2611, '19:00',1,4 UNION ALL 
        SELECT 2,133, '19:00',1,3 UNION ALL 
        SELECT 3,347, '08:00',1,3 UNION ALL 
        SELECT 4,567, '19:00',1,5 UNION ALL 
        SELECT 5,558, '19:00',1,11 UNION ALL 
        SELECT 6,808, '08:00',1,7 UNION ALL 
        SELECT 7,294, '08:00',1,4 UNION ALL 
        SELECT 28,1555, '07:00',1,1 UNION ALL 
        SELECT 9,323, '19:00',1,3 UNION ALL 
        SELECT 10,84, '08:00',1,15 UNION ALL 
        SELECT 11,321, '19:00',1,3 UNION ALL 
        SELECT 12,576, '19:00',1,3 UNION ALL 
        SELECT 13,941, '19:00',1,3 UNION ALL 
        SELECT 14,199, '19:00',1,3 UNION ALL 
        SELECT 23,310, '20:30',1,4 UNION ALL 
        SELECT 16,2266, '08:00',1,4 UNION ALL 
        SELECT 17,395, '08:00',1,13 UNION ALL 
        SELECT 18,326, '08:00',1,15 UNION ALL 
        SELECT 19,2245, '08:00',1,4 UNION ALL 
        SELECT 20,2269, '08:00',1,6 UNION ALL 
        SELECT 21,62, '08:00',1,3 UNION ALL 
        SELECT 22,1596, '19:00',1,5 UNION ALL 
        SELECT 24,2610, '07:00',1,5 UNION ALL 
        SELECT 25,204, '09:05',1,3 UNION ALL 
        SELECT 26,1543, '19:00',1,1 UNION ALL 
        SELECT 27,1405, '19:00',1,3 UNION ALL 
        SELECT 29,1814, '20:00:00',1,1 UNION ALL 
        SELECT 31,1019, '',1,3 UNION ALL 
        SELECT 32,878, '21:00',1,6 UNION ALL 
        SELECT 33,2334, '19:00',1,9 UNION ALL 
        SELECT 34,1145, '22:00',1,71 UNION ALL 
        SELECT 35,1509, '23:00',1,9 UNION ALL 
        SELECT 36,2438, '23:00',1,1 UNION ALL 
        SELECT 37,2247, '12:30:00',1,5 UNION ALL 
        SELECT 38,302, '20:30:00',1,5 UNION ALL 
        SELECT 39,2313, '21:30:00',1,5 UNION ALL 
        SELECT 40,183, '22:30:00',1,1 UNION ALL 
        SELECT 41,2288, '21:00:00',1,3 UNION ALL 
        SELECT 42,1377, '21:30',1,3 UNION ALL 
        SELECT 43,2482, '08:00',1,5 UNION ALL 
        SELECT 44,2215, '21:15:00',1,1 UNION ALL 
        SELECT 45,901, '20:00',1,7 UNION ALL 
        SELECT 46,556, '12:00',1,3 UNION ALL 
        SELECT 47,2572, '19:00',1,1 
 
        SET IDENTITY_INSERT TValScheduleConfig OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '509B1532-4E4A-46C4-8E2D-E4B7C328DD87', 
         'Initial load (44 total rows, file 1 of 1) for table TValScheduleConfig',
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
-- #Rows Exported: 44
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
