 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefFactFindCategoryPlanType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '00C5BFBD-BCBD-49B9-9F32-56E3309EFD77'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFactFindCategoryPlanType ON; 
 
        INSERT INTO TRefFactFindCategoryPlanType([RefFactFindCategoryPlanTypeId], [Category], [RefFactFindCategoryId], [RefPlanTypeId], [ConcurrencyId])
        SELECT 1, 'Investments',2,82,1 UNION ALL 
        SELECT 2, 'Investments',2,25,1 UNION ALL 
        SELECT 3, 'Investments',2,75,1 UNION ALL 
        SELECT 4, 'Investments',2,36,1 UNION ALL 
        SELECT 5, 'Investments',2,46,1 UNION ALL 
        SELECT 6, 'Investments',2,62,1 UNION ALL 
        SELECT 7, 'Investments',2,28,1 UNION ALL 
        SELECT 8, 'Investments',2,27,1 UNION ALL 
        SELECT 9, 'Investments',2,29,1 UNION ALL 
        SELECT 10, 'Investments',2,26,1 UNION ALL 
        SELECT 11, 'Investments',2,48,1 UNION ALL 
        SELECT 12, 'Investments',2,49,1 UNION ALL 
        SELECT 13, 'Investments',2,44,1 UNION ALL 
        SELECT 14, 'Investments',2,41,1 UNION ALL 
        SELECT 15, 'Investments',2,31,1 UNION ALL 
        SELECT 16, 'Investments',2,32,1 UNION ALL 
        SELECT 17, 'Investments',2,30,1 UNION ALL 
        SELECT 18, 'Investments',2,79,1 UNION ALL 
        SELECT 19, 'Investments',2,57,1 UNION ALL 
        SELECT 20, 'Investments',2,34,1 UNION ALL 
        SELECT 21, 'Investments',2,38,1 UNION ALL 
        SELECT 22, 'Investments',2,35,1 UNION ALL 
        SELECT 23, 'Investments',2,40,1 UNION ALL 
        SELECT 24, 'Investments',2,47,1 UNION ALL 
        SELECT 25, 'Investments',2,39,1 UNION ALL 
        SELECT 26, 'Investments',2,43,1 UNION ALL 
        SELECT 27, 'Investments',2,42,1 UNION ALL 
        SELECT 28, 'Investments',2,81,1 UNION ALL 
        SELECT 29, 'Investments',2,33,1 UNION ALL 
        SELECT 30, 'Investments',2,53,1 UNION ALL 
        SELECT 31, 'Investments',2,56,1 UNION ALL 
        SELECT 32, 'Protection',3,51,1 UNION ALL 
        SELECT 33, 'Protection',3,50,1 UNION ALL 
        SELECT 34, 'Protection',3,54,1 UNION ALL 
        SELECT 35, 'Protection',3,58,1 UNION ALL 
        SELECT 36, 'Protection',3,52,1 UNION ALL 
        SELECT 37, 'Protection',3,74,1 UNION ALL 
        SELECT 38, 'Protection',3,19,1 UNION ALL 
        SELECT 39, 'Protection',3,60,1 UNION ALL 
        SELECT 40, 'Protection',3,59,1 UNION ALL 
        SELECT 41, 'Protection',3,61,1 UNION ALL 
        SELECT 42, 'Protection',3,55,1 UNION ALL 
        SELECT 43, 'Pensions',4,11,1 UNION ALL 
        SELECT 44, 'Pensions',4,16,1 UNION ALL 
        SELECT 45, 'Pensions',4,4,1 UNION ALL 
        SELECT 46, 'Pensions',4,13,1 UNION ALL 
        SELECT 47, 'Pensions',4,6,1 UNION ALL 
        SELECT 48, 'Pensions',4,17,1 UNION ALL 
        SELECT 49, 'Pensions',4,14,1 UNION ALL 
        SELECT 50, 'Pensions',4,72,1 UNION ALL 
        SELECT 51, 'Pensions',4,20,1 UNION ALL 
        SELECT 52, 'Pensions',4,23,1 UNION ALL 
        SELECT 53, 'Pensions',4,71,1 UNION ALL 
        SELECT 54, 'Pensions',4,3,1 UNION ALL 
        SELECT 55, 'Pensions',4,21,1 UNION ALL 
        SELECT 56, 'Pensions',4,5,1 UNION ALL 
        SELECT 57, 'Pensions',4,1,1 UNION ALL 
        SELECT 58, 'Pensions',4,2,1 UNION ALL 
        SELECT 59, 'Pensions',4,8,1 UNION ALL 
        SELECT 60, 'Pensions',4,10,1 UNION ALL 
        SELECT 61, 'Pensions',4,7,1 UNION ALL 
        SELECT 62, 'Pensions',4,15,1 UNION ALL 
        SELECT 63, 'Pensions',4,24,1 UNION ALL 
        SELECT 64, 'Pensions',4,22,1 UNION ALL 
        SELECT 65, 'Pensions',4,18,1 UNION ALL 
        SELECT 66, 'Pensions',4,12,1 UNION ALL 
        SELECT 67, 'Pensions',4,9,1 UNION ALL 
        SELECT 68, 'Mortgage',5,63,1 UNION ALL 
        SELECT 69, 'Investments',2,85,1 UNION ALL 
        SELECT 70, 'Investments',2,86,1 UNION ALL 
        SELECT 71, 'Investments',2,87,1 UNION ALL 
        SELECT 72, 'Investments',2,88,1 UNION ALL 
        SELECT 74, 'Investments',2,78,1 UNION ALL 
        SELECT 75, 'Investments',2,37,1 UNION ALL 
        SELECT 76, 'Mortgage',5,64,1 UNION ALL 
        SELECT 77, 'Mortgage',5,70,1 UNION ALL 
        SELECT 78, 'Pensions',4,89,1 UNION ALL 
        SELECT 79, 'Pensions',4,90,1 UNION ALL 
        SELECT 80, 'Pensions',4,91,1 UNION ALL 
        SELECT 81, 'Protection',3,93,1 UNION ALL 
        SELECT 82, 'Protection',3,94,1 UNION ALL 
        SELECT 83, 'Protection',3,95,1 UNION ALL 
        SELECT 86, 'Pensions',4,99,1 UNION ALL 
        SELECT 87, 'Investments',2,100,1 UNION ALL 
        SELECT 88, 'Investments',2,101,1 UNION ALL 
        SELECT 89, 'All Plan Types',1,102,1 UNION ALL 
        SELECT 90, 'Investments',2,103,1 UNION ALL 
        SELECT 91, 'Protection',3,104,1 UNION ALL 
        SELECT 92, 'All Plan Types',NULL,92,1 UNION ALL 
        SELECT 93, 'Investments',2,105,1 UNION ALL 
        SELECT 94, 'All Plan Types',NULL,84,1 UNION ALL 
        SELECT 95, 'Protection',3,97,1 UNION ALL 
        SELECT 96, 'Protection',3,106,1 UNION ALL 
        SELECT 97, 'Protection',3,96,1 UNION ALL 
        SELECT 98, 'Pensions',4,107,1 UNION ALL 
        SELECT 99, 'Pensions',4,108,1 UNION ALL 
        SELECT 100, 'Pensions',4,109,1 UNION ALL 
        SELECT 101, 'Pensions',4,110,1 UNION ALL 
        SELECT 102, 'Protection',3,111,1 UNION ALL 
        SELECT 73, 'Investments',2,45,1 UNION ALL 
        SELECT 103, 'Investments',2,98,1 UNION ALL 
        SELECT 104, 'All Plan Types',NULL,65,1 UNION ALL 
        SELECT 105, 'All Plan Types',NULL,83,1 UNION ALL 
        SELECT 106, 'All Plan Types',NULL,66,1 UNION ALL 
        SELECT 107, 'All Plan Types',1,77,1 UNION ALL 
        SELECT 108, 'All Plan Types',NULL,112,1 UNION ALL 
        SELECT 109, 'Investments',2,113,1 UNION ALL 
        SELECT 110, 'Investments',2,114,1 UNION ALL 
        SELECT 111, 'Pensions',4,115,1 UNION ALL 
        SELECT 112, 'Protection',3,116,1 UNION ALL 
        SELECT 113, 'Protection',3,117,1 UNION ALL 
        SELECT 114, 'Pensions',4,1000,1 UNION ALL 
        SELECT 115, 'Pensions',4,1001,1 UNION ALL 
        SELECT 116, 'Pensions',4,1002,1 UNION ALL 
        SELECT 117, 'Pensions',4,1003,1 UNION ALL 
        SELECT 118, 'Pensions',4,1004,1 UNION ALL 
        SELECT 119, 'Pensions',4,1005,1 UNION ALL 
        SELECT 120, 'Retirement',NULL,1006,1 UNION ALL 
        SELECT 121, 'Investments',2,1007,1 UNION ALL 
        SELECT 122, 'Pensions',4,1008,1 UNION ALL 
        SELECT 123, 'Investments',2,1009,1 UNION ALL 
        SELECT 124, 'Investments',2,1010,1 UNION ALL 
        SELECT 125, 'Investments',2,1011,1 UNION ALL 
        SELECT 126, 'Investments',2,1012,1 UNION ALL 
        SELECT 127, 'Protection',3,1013,1 UNION ALL 
        SELECT 128, 'Investments',2,1014,1 UNION ALL 
        SELECT 129, 'Investments',2,1015,1 UNION ALL 
        SELECT 130, 'Investments',2,1016,1 UNION ALL 
        SELECT 131, 'Investments',2,1017,1 UNION ALL 
        SELECT 132, 'Investments',2,1018,1 UNION ALL 
        SELECT 133, 'Investments',2,1019,1 UNION ALL 
        SELECT 134, 'Pensions',4,1020,1 UNION ALL 
        SELECT 135, 'Protection',3,1021,1 UNION ALL 
        SELECT 136, 'Pensions',4,1022,1 UNION ALL 
        SELECT 137, 'Investments',2,1023,1 UNION ALL 
        SELECT 138, 'Investments',2,1024,1 UNION ALL 
        SELECT 139, '',NULL,1025,1 UNION ALL 
        SELECT 140, 'Pensions',4,1026,1 UNION ALL 
        SELECT 141, 'Pensions',4,1027,1 UNION ALL 
        SELECT 142, 'Protection',3,1028,1 UNION ALL 
        SELECT 143, 'Pensions',4,1029,1 UNION ALL 
        SELECT 144, 'Protection',3,1032,1 UNION ALL 
        SELECT 145, 'Pensions',4,1030,1 UNION ALL 
        SELECT 146, 'Investments',2,1033,1 UNION ALL 
        SELECT 147, 'Investments',2,1034,1 UNION ALL 
        SELECT 148, 'Protection',3,1035,1 UNION ALL 
        SELECT 149, 'Investments',2,1036,1 UNION ALL 
        SELECT 150, 'Investments',2,1037,1 UNION ALL 
        SELECT 151, 'Investments',2,1038,1 UNION ALL 
        SELECT 152, 'Mortgage',5,1039,1 UNION ALL 
        SELECT 153, '',NULL,1040,1 UNION ALL 
        SELECT 154, 'Pensions',4,1041,1 UNION ALL 
        SELECT 163, 'Mortgage',5,1053,1 UNION ALL 
        SELECT 162, 'Pensions',4,1052,1 UNION ALL 
        SELECT 161, 'Pensions',4,1051,1 UNION ALL 
        SELECT 160, 'Pensions',4,1050,1 UNION ALL 
        SELECT 159, '',NULL,1048,1 UNION ALL 
        SELECT 158, '',NULL,1049,1 UNION ALL 
        SELECT 157, 'Investments',2,1044,1 UNION ALL 
        SELECT 156, 'Pensions',4,1043,1 UNION ALL 
        SELECT 155, 'Pensions',4,1042,1 UNION ALL 
        SELECT 164, 'Investments',2,1054,1 UNION ALL 
        SELECT 165, 'Protection',3,1055,1 UNION ALL 
        SELECT 166, 'Investments',2,1056,1 UNION ALL 
        SELECT 167, 'Investments ',2,1062,1 UNION ALL 
        SELECT 168, 'Protection',3,1060,1 UNION ALL 
        SELECT 169, 'Pensions',4,1058,1 UNION ALL 
        SELECT 170, 'Pensions',4,1064,1 UNION ALL 
        SELECT 171, 'Investments',2,1065,1 UNION ALL 
        SELECT 172, 'Investments',2,1067,1 UNION ALL 
        SELECT 173, 'Pensions',4,1066,1 UNION ALL 
        SELECT 174, 'Protection',3,1068,1 UNION ALL 
        SELECT 175, 'Pensions',4,1072,1 UNION ALL 
        SELECT 176, 'Pensions',4,1075,1 UNION ALL 
        SELECT 177, 'Pensions',4,1074,1 UNION ALL 
        SELECT 178, 'Protection',3,1069,1 UNION ALL 
        SELECT 179, 'Protection',3,1070,1 UNION ALL 
        SELECT 180, 'Investments',2,1076,1 UNION ALL 
        SELECT 181, 'Investments',2,1077,1 UNION ALL 
        SELECT 183, 'Pensions',4,1084,1 UNION ALL 
        SELECT 184, 'Pensions',4,1073,1 UNION ALL 
        SELECT 185, 'Protection',3,1071,1 UNION ALL 
        SELECT 182, 'Pensions',4,1081,1 
 
        SET IDENTITY_INSERT TRefFactFindCategoryPlanType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '00C5BFBD-BCBD-49B9-9F32-56E3309EFD77', 
         'Initial load (183 total rows, file 1 of 1) for table TRefFactFindCategoryPlanType',
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
-- #Rows Exported: 183
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
