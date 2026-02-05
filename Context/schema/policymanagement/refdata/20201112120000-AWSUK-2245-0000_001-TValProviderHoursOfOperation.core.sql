 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValProviderHoursOfOperation
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '856EE21F-A905-4FD8-876E-DFD95D6F74FD'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValProviderHoursOfOperation ON; 
 
        INSERT INTO TValProviderHoursOfOperation([ValProviderHoursOfOperationId], [RefProdProviderId], [AlwaysAvailableFg], [DayOfTheWeek], [StartHour], [EndHour], [StartMinute], [EndMinute], [ConcurrencyId])
        SELECT 1,2611,1, NULL,0,0,0,0,2 UNION ALL 
        SELECT 2,941,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 3,558,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 4,133,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 5,567,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 154,84,0, 'monday',8,20,0,0,1 UNION ALL 
        SELECT 7,199,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 124,294,0, 'monday',8,22,0,0,1 UNION ALL 
        SELECT 9,321,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 10,323,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 148,1555,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 117,347,0, 'monday',8,23,0,0,1 UNION ALL 
        SELECT 131,310,0, 'monday',8,23,0,0,2 UNION ALL 
        SELECT 14,576,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 58,395,0, 'monday',8,20,0,0,1 UNION ALL 
        SELECT 59,395,0, 'tuesday',8,20,0,0,1 UNION ALL 
        SELECT 60,395,0, 'wednesday',8,20,0,0,1 UNION ALL 
        SELECT 61,395,0, 'thursday',8,20,0,0,1 UNION ALL 
        SELECT 62,395,0, 'friday',8,20,0,0,1 UNION ALL 
        SELECT 63,395,0, 'saturday',8,20,0,0,1 UNION ALL 
        SELECT 64,395,0, 'sunday',0,0,0,0,1 UNION ALL 
        SELECT 51,326,0, 'monday',8,20,0,0,1 UNION ALL 
        SELECT 52,326,0, 'tuesday',8,20,0,0,1 UNION ALL 
        SELECT 53,326,0, 'wednesday',8,20,0,0,1 UNION ALL 
        SELECT 54,326,0, 'thursday',8,20,0,0,1 UNION ALL 
        SELECT 55,326,0, 'friday',8,20,0,0,1 UNION ALL 
        SELECT 56,326,0, 'saturday',8,13,0,0,1 UNION ALL 
        SELECT 57,326,0, 'sunday',0,0,0,0,1 UNION ALL 
        SELECT 29,2266,0, 'monday',8,20,0,0,2 UNION ALL 
        SELECT 30,2266,0, 'tuesday',8,20,0,0,2 UNION ALL 
        SELECT 31,2266,0, 'wednesday',8,20,0,0,2 UNION ALL 
        SELECT 32,2266,0, 'thursday',8,20,0,0,2 UNION ALL 
        SELECT 33,2266,0, 'friday',8,20,0,0,2 UNION ALL 
        SELECT 34,2266,0, 'saturday',8,16,0,0,2 UNION ALL 
        SELECT 35,2266,0, 'sunday',0,0,0,0,2 UNION ALL 
        SELECT 95,1596,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 65,2245,0, 'monday',8,22,0,0,2 UNION ALL 
        SELECT 66,2245,0, 'tuesday',8,22,0,0,2 UNION ALL 
        SELECT 67,2245,0, 'wednesday',8,22,0,0,2 UNION ALL 
        SELECT 68,2245,0, 'thursday',8,22,0,0,2 UNION ALL 
        SELECT 69,2245,0, 'friday',8,22,0,0,2 UNION ALL 
        SELECT 70,2245,0, 'saturday',8,22,0,0,2 UNION ALL 
        SELECT 71,2245,0, 'sunday',10,16,0,0,2 UNION ALL 
        SELECT 72,808,0, 'monday',7,20,30,0,1 UNION ALL 
        SELECT 73,808,0, 'tuesday',7,20,30,0,1 UNION ALL 
        SELECT 74,808,0, 'wednesday',7,20,30,0,1 UNION ALL 
        SELECT 75,808,0, 'thursday',7,20,30,0,1 UNION ALL 
        SELECT 76,808,0, 'friday',7,18,30,0,1 UNION ALL 
        SELECT 77,808,0, 'saturday',8,16,0,0,1 UNION ALL 
        SELECT 78,808,0, 'sunday',0,0,0,0,1 UNION ALL 
        SELECT 88,2269,0, 'monday',5,23,0,0,4 UNION ALL 
        SELECT 89,2269,0, 'tuesday',5,23,0,0,4 UNION ALL 
        SELECT 90,2269,0, 'wednesday',5,23,0,0,4 UNION ALL 
        SELECT 91,2269,0, 'thursday',5,23,0,0,4 UNION ALL 
        SELECT 92,2269,0, 'friday',5,23,0,0,4 UNION ALL 
        SELECT 93,2269,0, 'saturday',5,23,0,0,4 UNION ALL 
        SELECT 94,2269,0, 'sunday',5,23,0,0,4 UNION ALL 
        SELECT 155,84,0, 'tuesday',8,20,0,0,1 UNION ALL 
        SELECT 156,84,0, 'wednesday',8,20,0,0,1 UNION ALL 
        SELECT 157,84,0, 'thursday',8,20,0,0,1 UNION ALL 
        SELECT 158,84,0, 'friday',8,20,0,0,1 UNION ALL 
        SELECT 159,84,0, 'saturday',8,13,0,0,1 UNION ALL 
        SELECT 160,84,0, 'sunday',0,0,0,0,1 UNION ALL 
        SELECT 103,62,0, 'monday',8,20,0,0,1 UNION ALL 
        SELECT 104,62,0, 'tuesday',8,20,0,0,1 UNION ALL 
        SELECT 105,62,0, 'wednesday',8,20,0,0,1 UNION ALL 
        SELECT 106,62,0, 'thursday',8,20,0,0,1 UNION ALL 
        SELECT 107,62,0, 'friday',8,20,0,0,1 UNION ALL 
        SELECT 108,62,0, 'saturday',8,13,0,0,1 UNION ALL 
        SELECT 109,62,0, 'sunday',0,0,0,0,1 UNION ALL 
        SELECT 118,347,0, 'tuesday',8,23,0,0,1 UNION ALL 
        SELECT 119,347,0, 'wednesday',8,23,0,0,1 UNION ALL 
        SELECT 120,347,0, 'thursday',8,23,0,0,1 UNION ALL 
        SELECT 121,347,0, 'friday',8,23,0,0,1 UNION ALL 
        SELECT 122,347,0, 'saturday',8,20,0,0,1 UNION ALL 
        SELECT 123,347,0, 'sunday',8,20,0,0,1 UNION ALL 
        SELECT 125,294,0, 'tuesday',8,22,0,0,1 UNION ALL 
        SELECT 126,294,0, 'wednesday',8,22,0,0,1 UNION ALL 
        SELECT 127,294,0, 'thursday',8,22,0,0,1 UNION ALL 
        SELECT 128,294,0, 'friday',8,22,0,0,1 UNION ALL 
        SELECT 129,294,0, 'saturday',8,16,0,0,1 UNION ALL 
        SELECT 130,294,0, 'sunday',0,0,0,0,1 UNION ALL 
        SELECT 132,310,0, 'tuesday',8,23,0,0,2 UNION ALL 
        SELECT 133,310,0, 'wednesday',8,23,0,0,2 UNION ALL 
        SELECT 134,310,0, 'thursday',8,23,0,0,2 UNION ALL 
        SELECT 135,310,0, 'friday',8,23,0,0,2 UNION ALL 
        SELECT 136,310,0, 'saturday',8,23,0,0,2 UNION ALL 
        SELECT 137,310,0, 'sunday',8,23,0,0,2 UNION ALL 
        SELECT 138,2610,1, NULL,0,0,0,0,2 UNION ALL 
        SELECT 139,204,0, 'monday',9,23,0,50,1 UNION ALL 
        SELECT 140,204,0, 'tuesday',9,23,0,50,1 UNION ALL 
        SELECT 141,204,0, 'wednesday',9,23,0,50,1 UNION ALL 
        SELECT 142,204,0, 'thursday',9,23,0,50,1 UNION ALL 
        SELECT 143,204,0, 'friday',9,23,0,50,1 UNION ALL 
        SELECT 144,204,0, 'saturday',9,23,0,50,1 UNION ALL 
        SELECT 145,204,0, 'sunday',9,23,0,50,3 UNION ALL 
        SELECT 146,1543,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 147,1405,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 149,1814,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 151,1019,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 152,878,1, NULL,0,0,0,0,6 UNION ALL 
        SELECT 153,2334,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 161,1145,1, NULL,0,0,0,0,71 UNION ALL 
        SELECT 162,1509,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 181,2438,0, 'monday',6,22,0,0,1 UNION ALL 
        SELECT 164,2247,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 165,302,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 166,2313,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 167,183,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 168,2288,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 169,1377,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 170,2482,1, 'monday',8,23,0,0,1 UNION ALL 
        SELECT 171,2482,1, 'tuesday',8,23,0,0,1 UNION ALL 
        SELECT 172,2482,1, 'wednesday',8,23,0,0,1 UNION ALL 
        SELECT 173,2482,1, 'thursday',8,23,0,0,1 UNION ALL 
        SELECT 174,2482,1, 'friday',8,23,0,0,1 UNION ALL 
        SELECT 175,2482,1, 'saturday',8,20,0,0,1 UNION ALL 
        SELECT 176,2482,1, 'sunday',8,20,0,0,1 UNION ALL 
        SELECT 177,2215,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 178,901,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 179,556,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 180,2572,1, NULL,0,0,0,0,1 UNION ALL 
        SELECT 182,2438,0, 'tuesday',6,22,0,0,1 UNION ALL 
        SELECT 183,2438,0, 'wednesday',6,22,0,0,1 UNION ALL 
        SELECT 184,2438,0, 'thursday',6,22,0,0,1 UNION ALL 
        SELECT 185,2438,0, 'friday',6,22,0,0,1 UNION ALL 
        SELECT 186,2438,0, 'saturday',6,23,0,0,2 UNION ALL 
        SELECT 187,2438,0, 'sunday',6,22,0,0,1 
 
        SET IDENTITY_INSERT TValProviderHoursOfOperation OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '856EE21F-A905-4FD8-876E-DFD95D6F74FD', 
         'Initial load (128 total rows, file 1 of 1) for table TValProviderHoursOfOperation',
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
-- #Rows Exported: 128
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
