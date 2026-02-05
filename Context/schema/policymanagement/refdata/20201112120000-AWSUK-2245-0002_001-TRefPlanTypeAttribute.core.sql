 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPlanTypeAttribute
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'FDF53BB7-D6F6-4C4F-B737-8CDDD160FAF9'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPlanTypeAttribute ON; 
 
        INSERT INTO TRefPlanTypeAttribute([RefPlanTypeAttributeId], [RefPlanTypeId], [AttributeListId], [ConcurrencyId], [IsVisible])
        SELECT 1,1,1,1,0 UNION ALL 
        SELECT 2,2,1,1,0 UNION ALL 
        SELECT 3,3,1,1,0 UNION ALL 
        SELECT 4,4,1,1,0 UNION ALL 
        SELECT 5,6,1,1,0 UNION ALL 
        SELECT 6,7,1,1,0 UNION ALL 
        SELECT 7,8,1,1,0 UNION ALL 
        SELECT 8,9,1,1,0 UNION ALL 
        SELECT 9,10,1,1,0 UNION ALL 
        SELECT 10,11,1,1,0 UNION ALL 
        SELECT 11,13,1,1,0 UNION ALL 
        SELECT 12,14,1,1,0 UNION ALL 
        SELECT 13,15,1,1,0 UNION ALL 
        SELECT 14,16,1,1,0 UNION ALL 
        SELECT 15,17,1,1,1 UNION ALL 
        SELECT 16,21,1,1,0 UNION ALL 
        SELECT 17,22,1,1,0 UNION ALL 
        SELECT 18,26,1,1,1 UNION ALL 
        SELECT 19,27,1,1,1 UNION ALL 
        SELECT 20,28,1,1,0 UNION ALL 
        SELECT 21,31,1,1,0 UNION ALL 
        SELECT 22,32,1,1,1 UNION ALL 
        SELECT 23,39,1,1,0 UNION ALL 
        SELECT 24,41,1,1,0 UNION ALL 
        SELECT 25,42,1,1,1 UNION ALL 
        SELECT 26,44,1,1,0 UNION ALL 
        SELECT 27,46,1,1,1 UNION ALL 
        SELECT 68,85,17,1,0 UNION ALL 
        SELECT 29,62,1,1,0 UNION ALL 
        SELECT 30,5,2,1,1 UNION ALL 
        SELECT 31,6,3,1,1 UNION ALL 
        SELECT 32,12,2,1,1 UNION ALL 
        SELECT 33,23,4,1,0 UNION ALL 
        SELECT 34,31,5,1,0 UNION ALL 
        SELECT 35,32,5,1,0 UNION ALL 
        SELECT 36,32,6,1,0 UNION ALL 
        SELECT 39,61,9,1,1 UNION ALL 
        SELECT 40,64,10,1,1 UNION ALL 
        SELECT 41,1,3,1,1 UNION ALL 
        SELECT 42,3,3,1,1 UNION ALL 
        SELECT 43,63,10,1,1 UNION ALL 
        SELECT 44,20,1,1,0 UNION ALL 
        SELECT 52,70,1,1,1 UNION ALL 
        SELECT 53,70,10,1,1 UNION ALL 
        SELECT 56,64,13,1,1 UNION ALL 
        SELECT 57,83,14,1,0 UNION ALL 
        SELECT 58,58,15,1,0 UNION ALL 
        SELECT 59,26,16,1,0 UNION ALL 
        SELECT 60,28,16,1,0 UNION ALL 
        SELECT 61,82,16,1,0 UNION ALL 
        SELECT 62,26,17,1,0 UNION ALL 
        SELECT 63,28,17,1,0 UNION ALL 
        SELECT 64,82,17,1,0 UNION ALL 
        SELECT 65,85,1,1,1 UNION ALL 
        SELECT 79,1011,1,1,0 UNION ALL 
        SELECT 67,85,16,1,0 UNION ALL 
        SELECT 69,88,1,1,1 UNION ALL 
        SELECT 70,88,16,1,0 UNION ALL 
        SELECT 71,88,17,1,0 UNION ALL 
        SELECT 72,89,1,1,0 UNION ALL 
        SELECT 73,89,3,1,1 UNION ALL 
        SELECT 74,90,1,1,0 UNION ALL 
        SELECT 75,91,1,1,0 UNION ALL 
        SELECT 76,93,1,1,1 UNION ALL 
        SELECT 80,1016,1,1,1 UNION ALL 
        SELECT 81,1016,16,1,0 UNION ALL 
        SELECT 82,1016,17,1,0 UNION ALL 
        SELECT 83,1015,1,1,1 UNION ALL 
        SELECT 84,1015,16,1,0 UNION ALL 
        SELECT 85,1015,17,1,0 UNION ALL 
        SELECT 86,1017,4,1,0 UNION ALL 
        SELECT 87,3,18,1,0 UNION ALL 
        SELECT 88,23,18,1,0 UNION ALL 
        SELECT 89,28,18,1,0 UNION ALL 
        SELECT 90,1036,1,1,1 UNION ALL 
        SELECT 91,1036,16,1,0 UNION ALL 
        SELECT 92,1036,17,1,0 UNION ALL 
        SELECT 93,1041,1,1,0 UNION ALL 
        SELECT 94,1041,3,1,1 UNION ALL 
        SELECT 95,1041,18,1,0 UNION ALL 
        SELECT 96,1042,1,1,0 UNION ALL 
        SELECT 97,1042,3,1,1 UNION ALL 
        SELECT 98,1042,18,1,0 UNION ALL 
        SELECT 99,8,3,1,1 UNION ALL 
        SELECT 100,8,18,1,0 UNION ALL 
        SELECT 101,1050,1,1,0 UNION ALL 
        SELECT 102,1050,3,1,1 UNION ALL 
        SELECT 103,1051,1,1,0 UNION ALL 
        SELECT 104,1033,1,1,0 UNION ALL 
        SELECT 105,1033,5,1,0 UNION ALL 
        SELECT 106,1064,2,1,1 UNION ALL 
        SELECT 107,95,1,1,1 UNION ALL 
        SELECT 108,51,8,1,1 UNION ALL 
        SELECT 109,51,11,1,1 UNION ALL 
        SELECT 113,1066,1,1,1 UNION ALL 
        SELECT 114,1066,3,1,1 UNION ALL 
        SELECT 115,1066,18,1,1 UNION ALL 
        SELECT 116,1074,4,1,1 UNION ALL 
        SELECT 117,1074,18,1,1 UNION ALL 
        SELECT 118,1068,8,1,1 UNION ALL 
        SELECT 119,1068,11,1,1 UNION ALL 
        SELECT 120,1069,8,1,1 UNION ALL 
        SELECT 121,1069,11,1,1 UNION ALL 
        SELECT 122,1070,8,1,1 UNION ALL 
        SELECT 123,1070,11,1,1 UNION ALL 
        SELECT 124,1081,1,1,1 UNION ALL 
        SELECT 126,1084,1,1,1 UNION ALL 
        SELECT 127,1084,3,1,1 UNION ALL 
        SELECT 128,1073,1,1,1 UNION ALL 
        SELECT 129,1073,3,1,1 UNION ALL 
        SELECT 125,1075,4,1,1 
 
        SET IDENTITY_INSERT TRefPlanTypeAttribute OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'FDF53BB7-D6F6-4C4F-B737-8CDDD160FAF9', 
         'Initial load (111 total rows, file 1 of 1) for table TRefPlanTypeAttribute',
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
-- #Rows Exported: 111
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
