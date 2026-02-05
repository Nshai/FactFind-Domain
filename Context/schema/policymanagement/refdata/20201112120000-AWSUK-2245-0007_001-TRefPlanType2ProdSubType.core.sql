 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPlanType2ProdSubType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'B59AFF13-3C4F-4EA2-B4E8-885D07B8E7BE'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPlanType2ProdSubType ON; 
 
        INSERT INTO TRefPlanType2ProdSubType([RefPlanType2ProdSubTypeId], [RefPlanTypeId], [ProdSubTypeId], [DefaultCategory], [ConcurrencyId], [IsArchived], [IsConsumerFriendly], [RefPortfolioCategoryId], [RefPlanDiscriminatorId], [RegionCode])
        SELECT 1,31,1, 'Retail Investments',30,0,0,1,8, 'GB' UNION ALL 
        SELECT 2,31,2, 'Non-Regulated',30,0,0,1,9, 'GB' UNION ALL 
        SELECT 3,31,3, 'Retail Investments',28,0,0,1,16, 'GB' UNION ALL 
        SELECT 4,31,4, 'Retail Investments',30,0,0,1,8, 'GB' UNION ALL 
        SELECT 5,31,5, 'Retail Investments',24,0,0,1,9, 'GB' UNION ALL 
        SELECT 6,1,NULL, 'Retail Investments',28,0,1,4,6, 'GB' UNION ALL 
        SELECT 7,2,NULL, 'Retail Investments',26,0,1,4,6, 'GB' UNION ALL 
        SELECT 8,3,NULL, 'Retail Investments',27,0,1,4,6, 'GB' UNION ALL 
        SELECT 9,4,NULL, 'Retail Investments',27,0,1,4,6, 'GB' UNION ALL 
        SELECT 10,5,NULL, 'Retail Investments',28,0,1,4,6, 'GB' UNION ALL 
        SELECT 11,6,NULL, 'Retail Investments',27,0,1,4,6, 'GB' UNION ALL 
        SELECT 12,7,NULL, 'Retail Investments',25,0,1,4,6, 'GB' UNION ALL 
        SELECT 13,8,NULL, 'Retail Investments',26,0,1,4,6, 'GB' UNION ALL 
        SELECT 14,9,NULL, 'Retail Investments',26,0,0,1,6, 'GB' UNION ALL 
        SELECT 15,10,NULL, 'Retail Investments',27,0,0,4,6, 'GB' UNION ALL 
        SELECT 16,11,NULL, 'Retail Investments',24,0,1,4,6, 'GB' UNION ALL 
        SELECT 17,12,NULL, 'Retail Investments',27,0,0,4,6, 'GB' UNION ALL 
        SELECT 18,13,NULL, 'Retail Investments',24,0,1,4,6, 'GB' UNION ALL 
        SELECT 19,14,NULL, 'Retail Investments',26,0,1,4,6, 'GB' UNION ALL 
        SELECT 20,15,NULL, 'Retail Investments',23,0,1,4,6, 'GB' UNION ALL 
        SELECT 21,16,NULL, 'Retail Investments',23,0,1,4,6, 'GB' UNION ALL 
        SELECT 22,17,NULL, 'Retail Investments',25,0,1,4,5, 'GB' UNION ALL 
        SELECT 23,18,NULL, 'Non-Investment Insurance',30,0,1,3,10, 'GB' UNION ALL 
        SELECT 24,19,NULL, 'Non-Investment Insurance',28,0,0,3,15, 'GB' UNION ALL 
        SELECT 25,20,NULL, 'Retail Investments',25,0,1,4,6, 'GB' UNION ALL 
        SELECT 26,21,NULL, 'Retail Investments',28,0,1,4,6, 'GB' UNION ALL 
        SELECT 27,22,NULL, 'Retail Investments',28,0,1,4,6, 'GB' UNION ALL 
        SELECT 28,23,NULL, 'Retail Investments',29,0,1,4,7, 'GB' UNION ALL 
        SELECT 29,24,NULL, 'Retail Investments',23,0,0,4,7, 'GB' UNION ALL 
        SELECT 30,25,NULL, 'Non-Regulated',26,0,0,1,9, 'GB' UNION ALL 
        SELECT 31,26,NULL, 'Retail Investments',30,0,1,1,8, 'GB' UNION ALL 
        SELECT 32,27,NULL, 'Retail Investments',24,0,1,1,8, 'GB' UNION ALL 
        SELECT 33,28,NULL, 'Retail Investments',29,0,1,1,16, 'GB' UNION ALL 
        SELECT 34,29,NULL, 'Non-Regulated',23,0,1,6,9, 'GB' UNION ALL 
        SELECT 35,30,NULL, 'Non-Regulated',23,0,0,1,8, 'GB' UNION ALL 
        SELECT 36,32,NULL, 'Retail Investments',26,0,1,1,8, 'GB' UNION ALL 
        SELECT 37,33,1059, 'Non-Regulated',24,0,1,1,8, 'GB' UNION ALL 
        SELECT 38,34,1059, 'Non-Regulated',23,0,1,1,8, 'GB' UNION ALL 
        SELECT 39,35,NULL, 'Non-Regulated',24,0,0,1,8, 'GB' UNION ALL 
        SELECT 40,36,NULL, 'Non-Regulated',23,0,0,1,8, 'GB' UNION ALL 
        SELECT 41,37,NULL, 'Non-Regulated',22,0,0,1,8, 'GB' UNION ALL 
        SELECT 42,38,NULL, 'Non-Regulated',23,0,0,1,8, 'GB' UNION ALL 
        SELECT 43,39,NULL, 'Retail Investments',27,0,1,1,16, 'GB' UNION ALL 
        SELECT 44,40,NULL, 'Retail Investments',28,0,1,6,16, 'GB' UNION ALL 
        SELECT 45,41,NULL, 'Retail Investments',27,0,0,6,16, 'GB' UNION ALL 
        SELECT 46,42,NULL, 'Retail Investments',30,0,1,1,8, 'GB' UNION ALL 
        SELECT 47,43,NULL, 'Non-Regulated',30,0,1,1,8, 'GB' UNION ALL 
        SELECT 48,44,NULL, 'Retail Investments',30,0,1,1,16, 'GB' UNION ALL 
        SELECT 49,45,NULL, 'Retail Investments',24,0,1,1,16, 'GB' UNION ALL 
        SELECT 50,46,NULL, 'Retail Investments',24,0,1,1,8, 'GB' UNION ALL 
        SELECT 51,47,NULL, 'Retail Investments',22,0,0,1,8, 'GB' UNION ALL 
        SELECT 52,48,NULL, 'Retail Investments',30,0,1,1,16, 'GB' UNION ALL 
        SELECT 53,49,NULL, 'Retail Investments',30,0,1,1,16, 'GB' UNION ALL 
        SELECT 54,50,NULL, 'Retail Investments',30,0,0,3,10, 'GB' UNION ALL 
        SELECT 55,51,NULL, 'Non-Investment Insurance',31,0,1,3,10, 'GB' UNION ALL 
        SELECT 56,52,NULL, 'Non-Investment Insurance',29,0,1,3,10, 'GB' UNION ALL 
        SELECT 57,53,NULL, 'Retail Investments',27,0,1,3,11, 'GB' UNION ALL 
        SELECT 58,54,NULL, 'Non-Investment Insurance',25,0,1,3,10, 'GB' UNION ALL 
        SELECT 59,55,NULL, 'Non-Investment Insurance',23,0,1,3,11, 'GB' UNION ALL 
        SELECT 60,56,NULL, 'Retail Investments',27,0,0,1,7, 'GB' UNION ALL 
        SELECT 61,57,NULL, 'Regulated Mortgage Contracts',20,1,0,3,15, 'GB' UNION ALL 
        SELECT 62,58,NULL, 'Non-Investment Insurance',28,0,1,3,11, 'GB' UNION ALL 
        SELECT 63,59,NULL, 'Non-Investment Insurance',29,0,0,3,15, 'GB' UNION ALL 
        SELECT 64,60,NULL, 'Non-Investment Insurance',29,0,0,3,15, 'GB' UNION ALL 
        SELECT 65,61,NULL, 'Non-Investment Insurance',28,0,0,3,15, 'GB' UNION ALL 
        SELECT 66,62,NULL, 'Retail Investments',28,0,0,1,16, 'GB' UNION ALL 
        SELECT 67,63,NULL, 'Regulated Mortgage Contracts',24,1,0,2,12, 'GB' UNION ALL 
        SELECT 68,64,NULL, 'Regulated Mortgage Contracts',23,0,1,2,13, 'GB' UNION ALL 
        SELECT 69,65,NULL, 'Non-Regulated',21,0,0,1,8, 'GB' UNION ALL 
        SELECT 70,66,NULL, 'Non-Regulated',24,0,0,1,8, 'GB' UNION ALL 
        SELECT 74,70,NULL, 'Non-Regulated',23,1,0,2,12, 'GB' UNION ALL 
        SELECT 75,71,NULL, 'Non-Investment Insurance',28,0,1,3,10, 'GB' UNION ALL 
        SELECT 76,72,NULL, 'Retail Investments',20,0,1,4,6, 'GB' UNION ALL 
        SELECT 78,74,NULL, 'Non-Investment Insurance',29,0,0,3,15, 'GB' UNION ALL 
        SELECT 79,75,NULL, 'Non-Regulated',24,0,1,6,9, 'GB' UNION ALL 
        SELECT 81,77,NULL, 'Non-Regulated',23,1,0,NULL,NULL, 'GB' UNION ALL 
        SELECT 82,78,NULL, 'Retail Investments',22,0,0,3,10, 'GB' UNION ALL 
        SELECT 83,79,NULL, 'Non-Regulated',23,0,0,1,8, 'GB' UNION ALL 
        SELECT 85,81,NULL, 'Non-Regulated',23,0,0,1,8, 'GB' UNION ALL 
        SELECT 86,82,NULL, 'Retail Investments',23,0,1,1,8, 'GB' UNION ALL 
        SELECT 87,83,NULL, 'Non-Regulated',21,0,1,5,14, 'GB' UNION ALL 
        SELECT 88,84,NULL, 'Non-Regulated',21,0,0,2,12, 'GB' UNION ALL 
        SELECT 89,85,NULL, 'Retail Investments',29,0,1,1,8, 'GB' UNION ALL 
        SELECT 90,86,NULL, 'Retail Investments',23,0,1,1,8, 'GB' UNION ALL 
        SELECT 91,51,6, 'Non-Investment Insurance',31,0,1,3,10, 'GB' UNION ALL 
        SELECT 92,51,7, 'Non-Investment Insurance',31,0,1,3,10, 'GB' UNION ALL 
        SELECT 93,51,8, 'Non-Investment Insurance',29,0,0,3,10, 'GB' UNION ALL 
        SELECT 94,51,9, 'Non-Investment Insurance',31,0,1,3,10, 'GB' UNION ALL 
        SELECT 95,51,10, 'Non-Investment Insurance',29,0,0,3,10, 'GB' UNION ALL 
        SELECT 96,51,11, 'Non-Investment Insurance',31,0,1,3,10, 'GB' UNION ALL 
        SELECT 97,51,12, 'Non-Investment Insurance',29,0,0,3,10, 'GB' UNION ALL 
        SELECT 98,55,13, 'Non-Investment Insurance',23,0,1,3,11, 'GB' UNION ALL 
        SELECT 99,55,14, 'Non-Investment Insurance',23,0,1,3,11, 'GB' UNION ALL 
        SELECT 102,88,NULL, 'Retail Investments',27,0,1,1,8, 'GB' UNION ALL 
        SELECT 103,51,16, 'Non-Investment Insurance',31,0,1,3,10, 'GB' UNION ALL 
        SELECT 133,111,NULL, 'Non-Investment Insurance',24,0,1,3,11, 'GB' UNION ALL 
        SELECT 134,53,22, 'Non-Investment Insurance',25,0,0,3,11, 'GB' UNION ALL 
        SELECT 135,53,23, 'Retail Investments',25,0,0,3,11, 'GB' UNION ALL 
        SELECT 136,83,24, 'Non-Regulated',21,0,0,5,14, 'GB' UNION ALL 
        SELECT 137,83,25, 'Regulated Mortgage Contracts',21,0,0,5,14, 'GB' UNION ALL 
        SELECT 138,112,NULL, 'Non-Regulated',20,0,0,3,10, 'GB' UNION ALL 
        SELECT 141,31,28, 'Retail Investments',29,0,1,1,8, 'GB' UNION ALL 
        SELECT 142,31,29, 'Non-Regulated',31,0,1,1,9, 'GB' UNION ALL 
        SELECT 143,113,NULL, 'Retail Investments',28,0,1,1,8, 'GB' UNION ALL 
        SELECT 144,114,NULL, 'Retail Investments',24,0,1,1,8, 'GB' UNION ALL 
        SELECT 145,115,NULL, 'Non-Regulated',23,0,1,4,6, 'GB' UNION ALL 
        SELECT 146,116,NULL, 'Non-Investment Insurance',25,0,0,3,15, 'GB' UNION ALL 
        SELECT 147,117,NULL, 'Non-Investment Insurance',25,0,0,3,15, 'GB' UNION ALL 
        SELECT 148,63,30, 'Regulated Mortgage Contracts',26,1,1,2,12, 'GB' UNION ALL 
        SELECT 149,63,31, 'Regulated Mortgage Contracts',26,1,1,2,12, 'GB' UNION ALL 
        SELECT 150,63,32, 'Regulated Mortgage Contracts',26,1,1,2,12, 'GB' UNION ALL 
        SELECT 151,63,33, 'Regulated Mortgage Contracts',26,0,1,2,12, 'GB' UNION ALL 
        SELECT 152,63,34, 'Regulated Mortgage Contracts',26,0,1,2,12, 'GB' UNION ALL 
        SELECT 153,63,35, 'Regulated Mortgage Contracts',22,0,1,2,12, 'GB' UNION ALL 
        SELECT 1000,1000,1000, 'Retail Investments',8,0,0,4,6, 'GB' UNION ALL 
        SELECT 1001,1000,1001, 'Retail Investments',7,0,0,4,6, 'GB' UNION ALL 
        SELECT 1002,1001,NULL, 'Retail Investments',1,0,1,4,7, 'GB' UNION ALL 
        SELECT 1003,1002,NULL, 'Retail Investments',1,0,1,4,7, 'GB' UNION ALL 
        SELECT 1004,1003,NULL, 'Retail Investments',1,0,0,4,7, 'GB' UNION ALL 
        SELECT 1005,1004,NULL, 'Retail Investments',1,0,0,4,6, 'GB' UNION ALL 
        SELECT 1006,1005,NULL, 'Retail Investments',1,0,0,4,6, 'GB' UNION ALL 
        SELECT 1007,63,1002, 'Regulated Mortgage Contracts',1,0,1,2,12, 'GB' UNION ALL 
        SELECT 1008,63,1003, 'Regulated Mortgage Contracts',1,0,1,2,12, 'GB' UNION ALL 
        SELECT 1009,23,1004, 'Retail Investments',1,0,0,4,7, 'GB' UNION ALL 
        SELECT 1010,23,1005, 'Retail Investments',1,0,0,4,7, 'GB' UNION ALL 
        SELECT 1011,23,1006, 'Retail Investments',1,0,0,4,7, 'GB' UNION ALL 
        SELECT 1012,23,1007, 'Retail Investments',1,0,0,4,7, 'GB' UNION ALL 
        SELECT 1013,23,1008, 'Retail Investments',1,0,0,4,7, 'GB' UNION ALL 
        SELECT 1014,50,1009, 'Retail Investments',1,0,1,1,16, 'GB' UNION ALL 
        SELECT 1015,50,1010, 'Non-Investment Insurance',1,0,1,3,10, 'GB' UNION ALL 
        SELECT 1016,1006,NULL, 'Non-Regulated',1,0,1,3,15, 'GB' UNION ALL 
        SELECT 1017,1007,NULL, 'Retail Investments',1,0,1,1,8, 'GB' UNION ALL 
        SELECT 1018,1008,NULL, 'Retail Investments',1,0,0,4,6, 'GB' UNION ALL 
        SELECT 1019,28,1011, 'Retail Investments',1,0,0,1,16, 'GB' UNION ALL 
        SELECT 1020,28,1012, 'Retail Investments',1,0,0,1,16, 'GB' UNION ALL 
        SELECT 1021,52,1013, 'Non-Investment Insurance',1,0,1,3,10, 'GB' UNION ALL 
        SELECT 1022,52,1014, 'Non-Investment Insurance',1,0,1,3,10, 'GB' UNION ALL 
        SELECT 1023,51,1015, 'Non-Investment Insurance',1,0,1,3,10, 'GB' UNION ALL 
        SELECT 1024,1009,NULL, 'Non-Regulated',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1025,1010,NULL, 'Non-Regulated',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1026,1011,NULL, 'Retail Investments',1,0,1,6,16, 'GB' UNION ALL 
        SELECT 1027,1012,NULL, 'Non-Regulated',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1028,1013,NULL, 'Non-Investment Insurance',1,0,1,3,10, 'GB' UNION ALL 
        SELECT 1029,1014,NULL, 'Non-Regulated',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1030,1015,NULL, 'Retail Investments',1,0,1,1,8, 'GB' UNION ALL 
        SELECT 1031,1016,NULL, 'Non-Regulated',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1032,1017,NULL, 'Retail Investments',1,0,0,4,7, 'GB' UNION ALL 
        SELECT 1033,23,1016, 'Retail Investments',1,0,0,4,7, 'GB' UNION ALL 
        SELECT 1034,1018,NULL, 'Non-Regulated',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1035,1019,NULL, 'Non-Regulated',1,0,0,1,16, 'GB' UNION ALL 
        SELECT 1036,1020,NULL, 'Retail Investments',1,0,0,4,6, 'GB' UNION ALL 
        SELECT 1037,1021,NULL, 'Non-Investment Insurance',1,0,0,3,11, 'GB' UNION ALL 
        SELECT 1038,1022,NULL, 'Retail Investments',1,0,0,3,6, 'GB' UNION ALL 
        SELECT 1039,29,1017, 'Non-Regulated',1,0,1,6,9, 'GB' UNION ALL 
        SELECT 1040,29,1018, 'Non-Regulated',1,0,1,6,9, 'GB' UNION ALL 
        SELECT 1041,29,1019, 'Non-Regulated',1,0,1,6,9, 'GB' UNION ALL 
        SELECT 1042,29,1020, 'Non-Regulated',1,0,1,6,9, 'GB' UNION ALL 
        SELECT 1043,29,1021, 'Non-Regulated',1,0,1,6,9, 'GB' UNION ALL 
        SELECT 1044,29,1022, 'Non-Regulated',1,0,1,6,9, 'GB' UNION ALL 
        SELECT 1045,1023,NULL, 'Non-Regulated',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1046,85,1023, 'Retail Investments',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1047,85,1024, 'Retail Investments',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1048,1024,NULL, 'Retail Investments',1,0,0,1,7, 'GB' UNION ALL 
        SELECT 1049,1025,NULL, 'Non-Regulated',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1050,1026,NULL, 'Retail Investments',1,0,0,4,7, 'GB' UNION ALL 
        SELECT 1051,1027,NULL, 'Retail Investments',1,0,0,4,6, 'GB' UNION ALL 
        SELECT 1052,1028,NULL, 'Non-Investment Insurance',1,0,0,3,11, 'GB' UNION ALL 
        SELECT 1053,63,1025, 'Regulated Mortgage Contracts',1,1,1,2,12, 'GB' UNION ALL 
        SELECT 1054,1029,NULL, 'Retail Investments',1,0,0,4,7, 'GB' UNION ALL 
        SELECT 1057,1032,NULL, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1055,1030,1026, 'Retail Investments',1,0,1,4,6, 'GB' UNION ALL 
        SELECT 104,51,17, 'Non-Investment Insurance',31,0,1,3,10, 'GB' UNION ALL 
        SELECT 105,89,NULL, 'Retail Investments',26,0,1,4,6, 'GB' UNION ALL 
        SELECT 106,90,NULL, 'Retail Investments',25,0,1,4,6, 'GB' UNION ALL 
        SELECT 107,91,NULL, 'Retail Investments',24,0,1,4,6, 'GB' UNION ALL 
        SELECT 108,92,NULL, 'Non-Regulated',20,0,0,5,14, 'GB' UNION ALL 
        SELECT 109,93,NULL, 'Non-Investment Insurance',24,0,0,3,15, 'GB' UNION ALL 
        SELECT 110,94,NULL, 'Non-Investment Insurance',25,0,1,3,10, 'GB' UNION ALL 
        SELECT 111,95,NULL, 'Non-Investment Insurance',27,0,1,3,10, 'GB' UNION ALL 
        SELECT 112,96,NULL, 'Non-Investment Insurance',22,0,1,3,10, 'GB' UNION ALL 
        SELECT 117,99,NULL, 'Retail Investments',27,0,1,4,6, 'GB' UNION ALL 
        SELECT 118,31,18, 'Retail Investments',30,0,0,1,8, 'GB' UNION ALL 
        SELECT 115,97,NULL, 'Non-Investment Insurance',23,0,0,3,11, 'GB' UNION ALL 
        SELECT 119,100,NULL, 'Retail Investments',24,0,0,1,8, 'GB' UNION ALL 
        SELECT 120,101,NULL, 'Non-Regulated',22,0,0,1,8, 'GB' UNION ALL 
        SELECT 121,102,NULL, 'Non-Regulated',20,0,0,5,14, 'GB' UNION ALL 
        SELECT 100,55,15, 'Non-Investment Insurance',22,0,1,3,11, 'GB' UNION ALL 
        SELECT 101,87,NULL, 'Retail Investments',28,1,0,1,8, 'GB' UNION ALL 
        SELECT 116,98,NULL, 'Retail Investments',21,0,1,1,8, 'GB' UNION ALL 
        SELECT 122,103,NULL, 'Retail Investments',23,0,0,1,8, 'GB' UNION ALL 
        SELECT 123,104,NULL, 'Non-Investment Insurance',27,0,0,3,10, 'GB' UNION ALL 
        SELECT 124,51,19, 'Non-Investment Insurance',31,0,1,3,10, 'GB' UNION ALL 
        SELECT 125,105,NULL, 'Non-Regulated',26,0,1,8,9, 'GB' UNION ALL 
        SELECT 126,106,NULL, 'Non-Investment Insurance',20,0,1,3,15, 'GB' UNION ALL 
        SELECT 127,55,20, 'Non-Investment Insurance',21,0,1,3,11, 'GB' UNION ALL 
        SELECT 128,55,21, 'Non-Investment Insurance',21,0,1,3,11, 'GB' UNION ALL 
        SELECT 129,107,NULL, 'Retail Investments',26,0,0,4,6, 'GB' UNION ALL 
        SELECT 130,108,NULL, 'Retail Investments',26,0,0,4,6, 'GB' UNION ALL 
        SELECT 131,109,NULL, 'Retail Investments',24,0,0,4,5, 'GB' UNION ALL 
        SELECT 132,110,NULL, 'Retail Investments',25,0,0,4,6, 'GB' UNION ALL 
        SELECT 1056,1030,1027, 'Retail Investments',1,0,1,4,6, 'GB' UNION ALL 
        SELECT 1058,55,1028, 'Non-Investment Insurance',1,0,0,3,11, 'GB' UNION ALL 
        SELECT 1060,1033,1030, 'Non-Regulated',1,0,0,1,9, 'GB' UNION ALL 
        SELECT 1061,1033,1031, 'Retail Investments',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1059,55,1029, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1062,51,1032, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1063,85,1033, 'Retail Investments',2,0,0,1,8, 'GB' UNION ALL 
        SELECT 1064,1034,NULL, 'Non-Regulated',1,0,0,1,16, 'GB' UNION ALL 
        SELECT 1065,1035,NULL, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1068,85,1036, 'Retail Investments',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1069,51,1037, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1070,51,1038, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1071,51,1039, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1072,51,1040, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1073,55,1041, 'Non-Investment Insurance',1,0,0,3,11, 'GB' UNION ALL 
        SELECT 1074,1036,NULL, 'Retail Investments',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1075,55,1042, 'Non-Investment Insurance',1,0,0,3,11, 'GB' UNION ALL 
        SELECT 1076,55,1043, 'Non-Investment Insurance',1,0,0,3,11, 'GB' UNION ALL 
        SELECT 1077,1037,NULL, 'Retail Investments',2,0,0,1,8, 'GB' UNION ALL 
        SELECT 1078,1038,NULL, 'Retail Investments',2,0,0,1,8, 'GB' UNION ALL 
        SELECT 1079,33,1045, 'Retail Investments',1,0,1,1,8, 'GB' UNION ALL 
        SELECT 1080,34,1045, 'Retail Investments',1,0,1,1,8, 'GB' UNION ALL 
        SELECT 1081,63,1046, 'Regulated Mortgage Contracts',1,0,1,2,12, 'GB' UNION ALL 
        SELECT 1082,63,1047, 'Regulated Mortgage Contracts',1,0,1,2,12, 'GB' UNION ALL 
        SELECT 1083,63,1048, 'Regulated Mortgage Contracts',1,0,1,2,12, 'GB' UNION ALL 
        SELECT 1085,63,1050, 'Regulated Mortgage Contracts',1,0,1,2,12, 'GB' UNION ALL 
        SELECT 1086,63,1051, 'Regulated Mortgage Contracts',1,0,1,2,12, 'GB' UNION ALL 
        SELECT 1087,63,1052, 'Regulated Mortgage Contracts',1,0,1,2,12, 'GB' UNION ALL 
        SELECT 1088,63,1053, 'Regulated Mortgage Contracts',1,0,1,2,12, 'GB' UNION ALL 
        SELECT 1089,63,1054, 'Regulated Mortgage Contracts',1,0,1,2,12, 'GB' UNION ALL 
        SELECT 1090,1039,1055, 'Non-Regulated',1,0,0,2,12, 'GB' UNION ALL 
        SELECT 1091,1039,1056, 'Non-Regulated',1,0,0,2,12, 'GB' UNION ALL 
        SELECT 1093,1039,33, 'Non-Regulated',0,0,0,2,12, 'GB' UNION ALL 
        SELECT 1094,1040,NULL, 'Non-Regulated',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1095,1039,1057, 'Non-Regulated',1,0,0,2,12, 'GB' UNION ALL 
        SELECT 1096,1041,NULL, 'Non-Regulated',1,0,1,4,6, 'GB' UNION ALL 
        SELECT 1097,1042,NULL, 'Retail Investments',1,0,1,4,6, 'GB' UNION ALL 
        SELECT 1098,1043,NULL, 'Non-Regulated',1,0,1,4,6, 'GB' UNION ALL 
        SELECT 1099,31,1058, 'Retail Investments',1,0,1,1,8, 'GB' UNION ALL 
        SELECT 1100,1044,1059, 'Non-Regulated',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1103,1049,NULL, 'Non-Regulated',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1102,1048,NULL, 'Non-Regulated',2,0,0,1,8, 'GB' UNION ALL 
        SELECT 1104,1050,NULL, 'Retail Investments',1,0,1,4,6, 'GB' UNION ALL 
        SELECT 1101,1044,1045, 'Retail Investments',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1105,1051,NULL, 'Retail Investments',1,0,0,4,6, 'GB' UNION ALL 
        SELECT 1106,55,1060, 'Non-Investment Insurance',1,0,0,3,11, 'GB' UNION ALL 
        SELECT 1107,55,1061, 'Non-Investment Insurance',1,0,0,3,11, 'GB' UNION ALL 
        SELECT 1108,55,1062, 'Non-Investment Insurance',1,0,0,3,11, 'GB' UNION ALL 
        SELECT 1109,1052,NULL, 'Non-Regulated',1,0,0,4,5, 'GB' UNION ALL 
        SELECT 1110,1033,1063, 'Retail Investments',2,0,1,1,8, 'GB' UNION ALL 
        SELECT 1111,1030,1064, 'Retail Investments',1,0,0,4,6, 'GB' UNION ALL 
        SELECT 1112,1053,NULL, 'Non-Regulated',1,0,1,7,14, 'GB' UNION ALL 
        SELECT 154,63,38, 'Regulated Mortgage Contracts',1,0,0,2,12, 'GB' UNION ALL 
        SELECT 1119,31,1071, 'Retail Investments',1,0,1,1,8, 'GB' UNION ALL 
        SELECT 1116,31,1068, 'Retail Investments',1,0,1,1,8, 'GB' UNION ALL 
        SELECT 1113,1054,NULL, 'Retail Investments',1,0,0,1,7, 'GB' UNION ALL 
        SELECT 1114,1055,1066, 'Non-Investment Insurance',1,0,0,3,15, 'GB' UNION ALL 
        SELECT 1115,1055,1067, 'Non-Investment Insurance',1,0,0,3,15, 'GB' UNION ALL 
        SELECT 1120,1056,NULL, 'Retail Investments',1,0,1,1,9, 'GB' UNION ALL 
        SELECT 1118,63,1070, 'Regulated Mortgage Contracts',1,0,0,2,12, 'GB' UNION ALL 
        SELECT 1117,63,1069, 'Regulated Mortgage Contracts',1,0,0,2,12, 'GB' UNION ALL 
        SELECT 1126,1062,1074, 'Retail Investments',1,0,1,1,9, 'GB' UNION ALL 
        SELECT 1127,1062,1075, 'Retail Investments',1,0,1,1,8, 'GB' UNION ALL 
        SELECT 1124,1060,NULL, 'Non-Investment Insurance',2,0,0,3,10, 'GB' UNION ALL 
        SELECT 1122,1058,NULL, 'Retail Investments',2,0,0,4,6, 'GB' UNION ALL 
        SELECT 1123,1039,1073, 'Non-Regulated',2,0,0,2,12, 'GB' UNION ALL 
        SELECT 1121,1030,1072, 'Retail Investments',2,0,0,4,6, 'GB' UNION ALL 
        SELECT 1128,1064,NULL, 'Retail Investments',2,0,0,4,6, 'GB' UNION ALL 
        SELECT 1129,63,1076, 'Regulated Mortgage Contracts',2,0,1,2,12, 'GB' UNION ALL 
        SELECT 1130,1039,1077, 'Non-Regulated',2,0,0,2,12, 'GB' UNION ALL 
        SELECT 1131,1039,1078, 'Non-Regulated',2,0,0,2,12, 'GB' UNION ALL 
        SELECT 1132,55,1079, 'Non-Investment Insurance',2,0,0,3,11, 'GB' UNION ALL 
        SELECT 1133,55,1080, 'Non-Investment Insurance',2,0,0,3,11, 'GB' UNION ALL 
        SELECT 1143,1039,1090, 'Non-Regulated',1,0,1,2,12, 'GB' UNION ALL 
        SELECT 1147,1067,NULL, 'Retail Investments',1,0,0,1,8, 'GB' UNION ALL 
        SELECT 1142,63,1089, 'Regulated Mortgage Contracts',1,0,0,2,12, 'GB' UNION ALL 
        SELECT 1180,1075,1126, 'Retail Investments',1,0,1,4,7, 'AU' UNION ALL 
        SELECT 1181,1075,1127, 'Retail Investments',1,0,1,4,7, 'AU' UNION ALL 
        SELECT 1203,1075,1149, 'Retail Investments',1,0,1,4,7, 'AU' UNION ALL 
        SELECT 1149,1068,1095, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1150,1068,1096, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1155,1069,NULL, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1151,1068,1097, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1152,1068,1098, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1153,1068,1099, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1154,1068,1100, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1156,1070,1102, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1157,1070,1103, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1158,1070,1104, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1159,1070,1105, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1160,1084,NULL, 'Retail Investments',1,0,1,4,6, 'AU' UNION ALL 
        SELECT 1172,1073,NULL, 'Retail Investments',1,0,1,4,6, 'AU' UNION ALL 
        SELECT 1206,28,NULL, 'Retail Investments',1,0,1,1,16, 'AU' UNION ALL 
        SELECT 1146,1066,NULL, 'Retail Investments',1,0,1,4,6, 'GB' UNION ALL 
        SELECT 1148,1068,1094, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1164,1072,1110, 'Retail Investments',1,0,1,4,6, 'AU' UNION ALL 
        SELECT 1201,1081,NULL, 'Retail Investments',1,0,1,4,5, 'AU' UNION ALL 
        SELECT 1199,52,NULL, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1205,46,NULL, 'Retail Investments',1,0,1,1,8, 'AU' UNION ALL 
        SELECT 1135,1032,1082, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1136,1032,1083, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1137,1032,1084, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1138,1032,1085, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1139,1032,1086, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1140,1032,1087, 'Non-Investment Insurance',1,0,0,3,10, 'GB' UNION ALL 
        SELECT 1145,1065,NULL, 'Retail Investments',1,0,1,4,6, 'GB' UNION ALL 
        SELECT 1134,29,1081, 'Non-Regulated',1,0,1,1,9, 'GB' UNION ALL 
        SELECT 1210,1025,NULL, 'Retail Investments',1,0,1,1,8, 'AU' UNION ALL 
        SELECT 1211,1053,NULL, 'Non-Regulated',1,0,1,7,14, 'AU' UNION ALL 
        SELECT 1212,83,NULL, 'Non-Regulated',1,0,1,5,14, 'AU' UNION ALL 
        SELECT 1191,55,1137, 'Non-Investment Insurance',1,0,1,3,11, 'AU' UNION ALL 
        SELECT 1192,55,1138, 'Non-Investment Insurance',1,0,1,3,11, 'AU' UNION ALL 
        SELECT 1193,55,1139, 'Non-Investment Insurance',1,0,1,3,11, 'AU' UNION ALL 
        SELECT 1194,55,1140, 'Non-Investment Insurance',1,0,1,3,11, 'AU' UNION ALL 
        SELECT 1195,55,1141, 'Non-Investment Insurance',1,0,0,3,11, 'AU' UNION ALL 
        SELECT 1196,55,1142, 'Non-Investment Insurance',1,0,1,3,11, 'AU' UNION ALL 
        SELECT 1197,55,1143, 'Non-Investment Insurance',1,0,1,3,11, 'AU' UNION ALL 
        SELECT 1198,55,1144, 'Non-Investment Insurance',1,0,1,3,11, 'AU' UNION ALL 
        SELECT 1165,1072,1111, 'Retail Investments',1,0,1,4,6, 'AU' UNION ALL 
        SELECT 1166,1072,1112, 'Retail Investments',1,0,1,4,6, 'AU' UNION ALL 
        SELECT 1167,1072,1113, 'Retail Investments',1,0,1,4,6, 'AU' UNION ALL 
        SELECT 1168,1072,1114, 'Retail Investments',1,0,1,4,6, 'AU' UNION ALL 
        SELECT 1169,1072,1115, 'Retail Investments',1,0,1,4,6, 'AU' UNION ALL 
        SELECT 1170,1072,1116, 'Retail Investments',1,0,1,4,6, 'AU' UNION ALL 
        SELECT 1173,1074,1119, 'Retail Investments',1,0,1,4,7, 'AU' UNION ALL 
        SELECT 1174,1074,1120, 'Retail Investments',1,0,1,4,7, 'AU' UNION ALL 
        SELECT 1175,1074,1121, 'Retail Investments',1,0,1,4,7, 'AU' UNION ALL 
        SELECT 1176,1074,1122, 'Retail Investments',1,0,1,4,7, 'AU' UNION ALL 
        SELECT 1177,1074,1123, 'Retail Investments',1,0,1,4,7, 'AU' UNION ALL 
        SELECT 1178,1074,1124, 'Retail Investments',1,0,1,4,7, 'AU' UNION ALL 
        SELECT 1179,1074,1125, 'Retail Investments',1,0,1,4,7, 'AU' UNION ALL 
        SELECT 1182,1076,NULL, 'Retail Investments',1,0,1,1,8, 'AU' UNION ALL 
        SELECT 1183,1077,NULL, 'Retail Investments',1,0,1,1,8, 'AU' UNION ALL 
        SELECT 1202,1075,1148, 'Retail Investments',1,0,1,4,7, 'AU' UNION ALL 
        SELECT 1171,1071,1106, 'Non-Investment Insurance',1,0,1,3,11, 'AU' UNION ALL 
        SELECT 1161,1071,1107, 'Non-Investment Insurance',1,0,1,3,11, 'AU' UNION ALL 
        SELECT 1162,1071,1108, 'Non-Investment Insurance',1,0,1,3,11, 'AU' UNION ALL 
        SELECT 1163,1071,1109, 'Non-Investment Insurance',1,0,1,3,11, 'AU' UNION ALL 
        SELECT 1200,1070,1146, 'Non-Investment Insurance',1,0,1,3,10, 'AU' UNION ALL 
        SELECT 1204,113,NULL, 'Retail Investments',1,0,1,1,8, 'AU' 
 
        SET IDENTITY_INSERT TRefPlanType2ProdSubType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'B59AFF13-3C4F-4EA2-B4E8-885D07B8E7BE', 
         'Initial load (340 total rows, file 1 of 1) for table TRefPlanType2ProdSubType',
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
-- #Rows Exported: 340
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
