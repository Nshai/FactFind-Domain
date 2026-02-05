 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefPlanTypeToSection
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '54FB591D-2BFB-4D15-9C23-C484DA88FE15'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPlanTypeToSection ON; 
 
        INSERT INTO TRefPlanTypeToSection([RefPlanTypeToSectionId], [RefPlanType2ProdSubTypeId], [Section], [ConcurrencyId])
        SELECT 212,9, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 213,11, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 143,111, 'Protection',1 UNION ALL 
        SELECT 142,1024, 'Other Investments',1 UNION ALL 
        SELECT 141,1044, 'Other Investments',1 UNION ALL 
        SELECT 140,1043, 'Other Investments',1 UNION ALL 
        SELECT 139,1042, 'Other Investments',1 UNION ALL 
        SELECT 138,1041, 'Other Investments',1 UNION ALL 
        SELECT 137,1040, 'Other Investments',1 UNION ALL 
        SELECT 136,1039, 'Other Investments',1 UNION ALL 
        SELECT 135,1008, 'Mortgage',1 UNION ALL 
        SELECT 134,1007, 'Mortgage',1 UNION ALL 
        SELECT 133,153, 'Mortgage',1 UNION ALL 
        SELECT 132,152, 'Mortgage',1 UNION ALL 
        SELECT 131,151, 'Mortgage',1 UNION ALL 
        SELECT 130,150, 'Mortgage',1 UNION ALL 
        SELECT 129,149, 'Mortgage',1 UNION ALL 
        SELECT 128,148, 'Mortgage',1 UNION ALL 
        SELECT 282,1096, 'Pension Plans',1 UNION ALL 
        SELECT 126,68, 'Equity Release',1 UNION ALL 
        SELECT 125,100, 'Building and Contents Insurance',1 UNION ALL 
        SELECT 124,99, 'Building and Contents Insurance',1 UNION ALL 
        SELECT 123,98, 'Building and Contents Insurance',1 UNION ALL 
        SELECT 214,12, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 215,14, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 216,15, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 217,16, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 218,17, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 219,18, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 220,20, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 221,21, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 267,1079, 'Other Investments',1 UNION ALL 
        SELECT 223,145, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 224,1006, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 225,1016, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 226,1036, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 227,1038, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 228,1051, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 229,106, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 230,107, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 231,129, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 232,130, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 233,132, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 234,6, 'Pension Plans',1 UNION ALL 
        SELECT 235,7, 'Pension Plans',1 UNION ALL 
        SELECT 236,8, 'Pension Plans',1 UNION ALL 
        SELECT 237,10, 'Pension Plans',1 UNION ALL 
        SELECT 238,19, 'Pension Plans',1 UNION ALL 
        SELECT 239,25, 'Pension Plans',1 UNION ALL 
        SELECT 240,26, 'Pension Plans',1 UNION ALL 
        SELECT 241,27, 'Pension Plans',1 UNION ALL 
        SELECT 242,75, 'Pension Plans',1 UNION ALL 
        SELECT 243,1000, 'Pension Plans',1 UNION ALL 
        SELECT 244,1001, 'Pension Plans',1 UNION ALL 
        SELECT 245,1005, 'Pension Plans',1 UNION ALL 
        SELECT 246,1011, 'Annuities',1 UNION ALL 
        SELECT 247,1018, 'Pension Plans',1 UNION ALL 
        SELECT 248,1055, 'Pension Plans',1 UNION ALL 
        SELECT 249,105, 'Pension Plans',1 UNION ALL 
        SELECT 250,117, 'Pension Plans',1 UNION ALL 
        SELECT 251,1056, 'Pension Plans',1 UNION ALL 
        SELECT 252,13, 'Pension Plans',1 UNION ALL 
        SELECT 253,28, 'Annuities',1 UNION ALL 
        SELECT 82,22, 'Final Salary Schemes',1 UNION ALL 
        SELECT 81,1020, 'Other Investments',1 UNION ALL 
        SELECT 80,1019, 'Other Investments',1 UNION ALL 
        SELECT 79,1017, 'Other Investments',1 UNION ALL 
        SELECT 78,1014, 'Other Investments',1 UNION ALL 
        SELECT 77,144, 'Other Investments',1 UNION ALL 
        SELECT 76,142, 'Other Investments',1 UNION ALL 
        SELECT 75,141, 'Other Investments',1 UNION ALL 
        SELECT 74,122, 'Other Investments',1 UNION ALL 
        SELECT 73,119, 'Other Investments',1 UNION ALL 
        SELECT 72,118, 'Other Investments',1 UNION ALL 
        SELECT 71,90, 'Other Investments',1 UNION ALL 
        SELECT 70,89, 'Other Investments',1 UNION ALL 
        SELECT 69,86, 'Other Investments',1 UNION ALL 
        SELECT 68,85, 'Other Investments',1 UNION ALL 
        SELECT 67,83, 'Other Investments',1 UNION ALL 
        SELECT 66,66, 'Other Investments',1 UNION ALL 
        SELECT 65,61, 'Other Investments',1 UNION ALL 
        SELECT 64,60, 'Other Investments',1 UNION ALL 
        SELECT 173,1059, 'Protection',1 UNION ALL 
        SELECT 62,53, 'Other Investments',1 UNION ALL 
        SELECT 61,52, 'Other Investments',1 UNION ALL 
        SELECT 60,51, 'Other Investments',1 UNION ALL 
        SELECT 59,50, 'Other Investments',1 UNION ALL 
        SELECT 58,49, 'Other Investments',1 UNION ALL 
        SELECT 57,48, 'Other Investments',1 UNION ALL 
        SELECT 56,47, 'Other Investments',1 UNION ALL 
        SELECT 55,46, 'Other Investments',1 UNION ALL 
        SELECT 54,45, 'Other Investments',1 UNION ALL 
        SELECT 53,44, 'Other Investments',1 UNION ALL 
        SELECT 52,43, 'Other Investments',1 UNION ALL 
        SELECT 51,42, 'Other Investments',1 UNION ALL 
        SELECT 50,41, 'Other Investments',1 UNION ALL 
        SELECT 49,40, 'Other Investments',1 UNION ALL 
        SELECT 48,39, 'Other Investments',1 UNION ALL 
        SELECT 47,38, 'Other Investments',1 UNION ALL 
        SELECT 46,37, 'Other Investments',1 UNION ALL 
        SELECT 209,1074, 'Other Investments',1 UNION ALL 
        SELECT 210,1078, 'Other Investments',1 UNION ALL 
        SELECT 211,1077, 'Other Investments',1 UNION ALL 
        SELECT 254,29, 'Annuities',1 UNION ALL 
        SELECT 255,1002, 'Annuities',1 UNION ALL 
        SELECT 256,1003, 'Annuities',1 UNION ALL 
        SELECT 257,1004, 'Annuities',1 UNION ALL 
        SELECT 258,1009, 'Annuities',1 UNION ALL 
        SELECT 259,1010, 'Annuities',1 UNION ALL 
        SELECT 260,1012, 'Annuities',1 UNION ALL 
        SELECT 261,1013, 'Annuities',1 UNION ALL 
        SELECT 262,1032, 'Annuities',1 UNION ALL 
        SELECT 263,1033, 'Annuities',1 UNION ALL 
        SELECT 264,1048, 'Annuities',1 UNION ALL 
        SELECT 265,1050, 'Annuities',1 UNION ALL 
        SELECT 266,1054, 'Annuities',1 UNION ALL 
        SELECT 268,1080, 'Other Investments',1 UNION ALL 
        SELECT 269,76, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 270,1095, 'Mortgage',1 UNION ALL 
        SELECT 271,1081, 'Mortgage',1 UNION ALL 
        SELECT 272,1082, 'Mortgage',1 UNION ALL 
        SELECT 273,1083, 'Mortgage',1 UNION ALL 
        SELECT 274,1085, 'Mortgage',1 UNION ALL 
        SELECT 275,1086, 'Mortgage',1 UNION ALL 
        SELECT 276,1087, 'Mortgage',1 UNION ALL 
        SELECT 277,1088, 'Mortgage',1 UNION ALL 
        SELECT 278,1089, 'Mortgage',1 UNION ALL 
        SELECT 279,1090, 'Mortgage',1 UNION ALL 
        SELECT 280,1091, 'Mortgage',1 UNION ALL 
        SELECT 281,1093, 'Mortgage',1 UNION ALL 
        SELECT 283,1097, 'Pension Plans',1 UNION ALL 
        SELECT 284,1098, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 286,1100, 'Other Investments',1 UNION ALL 
        SELECT 287,1104, 'Pension Plans',1 UNION ALL 
        SELECT 288,1101, 'Other Investments',1 UNION ALL 
        SELECT 289,1105, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 290,67, 'Mortgage',1 UNION ALL 
        SELECT 291,1110, 'Other Investments',1 UNION ALL 
        SELECT 292,1111, 'Pension Plans',1 UNION ALL 
        SELECT 293,1119, 'Other Investments',1 UNION ALL 
        SELECT 294,1116, 'Other Investments',1 UNION ALL 
        SELECT 295,1113, 'Other Investments',1 UNION ALL 
        SELECT 296,1114, 'Protection',1 UNION ALL 
        SELECT 297,1115, 'Protection',1 UNION ALL 
        SELECT 298,1120, 'Other Investments',1 UNION ALL 
        SELECT 299,1118, 'Mortgage',1 UNION ALL 
        SELECT 300,1117, 'Mortgage',1 UNION ALL 
        SELECT 301,1126, 'Other Investments',1 UNION ALL 
        SELECT 302,1127, 'Other Investments',1 UNION ALL 
        SELECT 303,1124, 'Protection',1 UNION ALL 
        SELECT 304,1122, 'Pension Plans',1 UNION ALL 
        SELECT 305,1123, 'Mortgage',1 UNION ALL 
        SELECT 307,1128, 'Money Purchase Pension Schemes',1 UNION ALL 
        SELECT 208,1068, 'Other Investments',1 UNION ALL 
        SELECT 207,1064, 'Other Investments',1 UNION ALL 
        SELECT 206,1063, 'Other Investments',1 UNION ALL 
        SELECT 205,1072, 'Protection',1 UNION ALL 
        SELECT 204,1071, 'Protection',1 UNION ALL 
        SELECT 203,1070, 'Protection',1 UNION ALL 
        SELECT 202,1069, 'Protection',1 UNION ALL 
        SELECT 201,1065, 'Protection',1 UNION ALL 
        SELECT 200,1062, 'Protection',1 UNION ALL 
        SELECT 285,1099, 'Other Investments',1 UNION ALL 
        SELECT 198,35, 'Other Investments',1 UNION ALL 
        SELECT 197,1030, 'Other Investments',1 UNION ALL 
        SELECT 196,1025, 'Other Investments',1 UNION ALL 
        SELECT 306,1121, 'Pension Plans',1 UNION ALL 
        SELECT 194,1027, 'Other Investments',1 UNION ALL 
        SELECT 193,1028, 'Protection',1 UNION ALL 
        SELECT 318,1134, 'Other Investments',1 UNION ALL 
        SELECT 191,101, 'Other Investments',1 UNION ALL 
        SELECT 190,1045, 'Other Investments',1 UNION ALL 
        SELECT 189,1061, 'Other Investments',1 UNION ALL 
        SELECT 188,1060, 'Other Investments',1 UNION ALL 
        SELECT 319,1135, 'Protection',1 UNION ALL 
        SELECT 186,116, 'Other Investments',1 UNION ALL 
        SELECT 185,133, 'Protection',1 UNION ALL 
        SELECT 320,1136, 'Protection',1 UNION ALL 
        SELECT 321,1137, 'Protection',1 UNION ALL 
        SELECT 182,147, 'Protection',1 UNION ALL 
        SELECT 181,131, 'Final Salary Schemes',1 UNION ALL 
        SELECT 180,146, 'Protection',1 UNION ALL 
        SELECT 179,1031, 'Other Investments',1 UNION ALL 
        SELECT 312,135, 'Other Investments',1 UNION ALL 
        SELECT 313,134, 'Other Investments',1 UNION ALL 
        SELECT 176,115, 'Protection',1 UNION ALL 
        SELECT 171,123, 'Protection',1 UNION ALL 
        SELECT 314,1026, 'Other Investments',1 UNION ALL 
        SELECT 169,109, 'Protection',1 UNION ALL 
        SELECT 168,1052, 'Protection',1 UNION ALL 
        SELECT 167,1057, 'Protection',1 UNION ALL 
        SELECT 322,1138, 'Protection',1 UNION ALL 
        SELECT 323,1139, 'Protection',1 UNION ALL 
        SELECT 164,82, 'Other Investments',1 UNION ALL 
        SELECT 163,1034, 'Other Investments',1 UNION ALL 
        SELECT 162,1029, 'Other Investments',1 UNION ALL 
        SELECT 161,1035, 'Other Investments',1 UNION ALL 
        SELECT 160,135, 'Protection',1 UNION ALL 
        SELECT 159,134, 'Protection',1 UNION ALL 
        SELECT 175,120, 'Other Investments',1 UNION ALL 
        SELECT 174,1037, 'Protection',1 UNION ALL 
        SELECT 172,1058, 'Building and Contents Insurance',1 UNION ALL 
        SELECT 335,1147, 'Other Investments',1 UNION ALL 
        SELECT 154,112, 'Protection',1 UNION ALL 
        SELECT 324,1140, 'Protection',1 UNION ALL 
        SELECT 152,1049, 'Other Investments',1 UNION ALL 
        SELECT 151,1047, 'Other Investments',1 UNION ALL 
        SELECT 150,1046, 'Other Investments',1 UNION ALL 
        SELECT 45,36, 'Other Investments',1 UNION ALL 
        SELECT 44,34, 'Other Investments',1 UNION ALL 
        SELECT 43,33, 'Other Investments',1 UNION ALL 
        SELECT 42,32, 'Other Investments',1 UNION ALL 
        SELECT 41,31, 'Other Investments',1 UNION ALL 
        SELECT 40,5, 'Other Investments',1 UNION ALL 
        SELECT 39,4, 'Other Investments',1 UNION ALL 
        SELECT 38,3, 'Other Investments',1 UNION ALL 
        SELECT 37,2, 'Other Investments',1 UNION ALL 
        SELECT 36,1, 'Other Investments',1 UNION ALL 
        SELECT 35,125, 'Savings',1 UNION ALL 
        SELECT 34,79, 'Savings',1 UNION ALL 
        SELECT 33,30, 'Savings',1 UNION ALL 
        SELECT 32,1023, 'Protection',1 UNION ALL 
        SELECT 31,1022, 'Protection',1 UNION ALL 
        SELECT 30,1021, 'Protection',1 UNION ALL 
        SELECT 29,1015, 'Protection',1 UNION ALL 
        SELECT 28,124, 'Protection',1 UNION ALL 
        SELECT 27,110, 'Protection',1 UNION ALL 
        SELECT 26,104, 'Protection',1 UNION ALL 
        SELECT 25,103, 'Protection',1 UNION ALL 
        SELECT 24,97, 'Protection',1 UNION ALL 
        SELECT 23,96, 'Protection',1 UNION ALL 
        SELECT 22,95, 'Protection',1 UNION ALL 
        SELECT 21,94, 'Protection',1 UNION ALL 
        SELECT 20,93, 'Protection',1 UNION ALL 
        SELECT 19,92, 'Protection',1 UNION ALL 
        SELECT 18,91, 'Protection',1 UNION ALL 
        SELECT 17,78, 'Protection',1 UNION ALL 
        SELECT 325,43, 'Protection',1 UNION ALL 
        SELECT 15,65, 'Protection',1 UNION ALL 
        SELECT 14,64, 'Protection',1 UNION ALL 
        SELECT 13,63, 'Protection',1 UNION ALL 
        SELECT 12,62, 'Protection',1 UNION ALL 
        SELECT 11,58, 'Protection',1 UNION ALL 
        SELECT 10,57, 'Protection',1 UNION ALL 
        SELECT 9,56, 'Protection',1 UNION ALL 
        SELECT 8,55, 'Protection',1 UNION ALL 
        SELECT 7,54, 'Protection',1 UNION ALL 
        SELECT 6,49, 'Protection',1 UNION ALL 
        SELECT 5,44, 'Protection',1 UNION ALL 
        SELECT 326,66, 'Protection',1 UNION ALL 
        SELECT 3,41, 'Protection',1 UNION ALL 
        SELECT 2,24, 'Protection',1 UNION ALL 
        SELECT 1,23, 'Protection',1 UNION ALL 
        SELECT 334,1143, 'Mortgage',1 UNION ALL 
        SELECT 336,1146, 'Pension Plans',1 UNION ALL 
        SELECT 147,143, 'Other Investments',1 UNION ALL 
        SELECT 146,102, 'Other Investments',1 UNION ALL 
        SELECT 329,54, 'Other Investments',1 UNION ALL 
        SELECT 337,154, 'Mortgage',1 UNION ALL 
        SELECT 338,1129, 'Mortgage',1 UNION ALL 
        SELECT 332,1145, 'Annuities',1 UNION ALL 
        SELECT 339,1130, 'Mortgage',1 UNION ALL 
        SELECT 340,1131, 'Mortgage',1 UNION ALL 
        SELECT 341,1142, 'Mortgages',1 UNION ALL 
        SELECT 342,1148, 'Protection',1 UNION ALL 
        SELECT 343,1164, 'Pension Plans',1 UNION ALL 
        SELECT 344,1165, 'Pension Plans',1 UNION ALL 
        SELECT 345,1166, 'Pension Plans',1 UNION ALL 
        SELECT 346,1167, 'Pension Plans',1 UNION ALL 
        SELECT 347,1168, 'Pension Plans',1 UNION ALL 
        SELECT 348,1169, 'Pension Plans',1 UNION ALL 
        SELECT 349,1170, 'Pension Plans',1 UNION ALL 
        SELECT 350,1180, 'Pension Plans',1 UNION ALL 
        SELECT 351,1181, 'Pension Plans',1 UNION ALL 
        SELECT 352,1173, 'Annuities',1 UNION ALL 
        SELECT 353,1174, 'Annuities',1 UNION ALL 
        SELECT 354,1175, 'Annuities',1 UNION ALL 
        SELECT 355,1176, 'Annuities',1 UNION ALL 
        SELECT 356,1177, 'Annuities',1 UNION ALL 
        SELECT 357,1178, 'Annuities',1 UNION ALL 
        SELECT 358,1179, 'Annuities',1 UNION ALL 
        SELECT 360,1149, 'Protection',1 UNION ALL 
        SELECT 361,1150, 'Protection',1 UNION ALL 
        SELECT 362,1155, 'Protection',1 UNION ALL 
        SELECT 363,1151, 'Protection',1 UNION ALL 
        SELECT 364,1152, 'Protection',1 UNION ALL 
        SELECT 365,1153, 'Protection',1 UNION ALL 
        SELECT 366,1154, 'Protection',1 UNION ALL 
        SELECT 367,1156, 'Protection',1 UNION ALL 
        SELECT 368,1157, 'Protection',1 UNION ALL 
        SELECT 369,1158, 'Protection',1 UNION ALL 
        SELECT 370,1159, 'Protection',1 UNION ALL 
        SELECT 375,1160, 'Pension Plans',1 UNION ALL 
        SELECT 376,1172, 'Pension Plans',1 UNION ALL 
        SELECT 383,1206, 'Other Investments',1 UNION ALL 
        SELECT 385,1204, 'Other Investments',1 UNION ALL 
        SELECT 359,1203, 'Annuities',1 UNION ALL 
        SELECT 371,1182, 'Other Investments',1 UNION ALL 
        SELECT 372,1183, 'Other Investments',1 UNION ALL 
        SELECT 373,1201, 'Final Salary Schemes',1 UNION ALL 
        SELECT 374,1202, 'Annuities',1 UNION ALL 
        SELECT 377,1171, 'Protection',1 UNION ALL 
        SELECT 378,1161, 'Protection',1 UNION ALL 
        SELECT 379,1162, 'Protection',1 UNION ALL 
        SELECT 380,1163, 'Protection',1 UNION ALL 
        SELECT 381,1199, 'Protection',1 UNION ALL 
        SELECT 382,1200, 'Protection',1 UNION ALL 
        SELECT 384,1205, 'Other Investments',1 UNION ALL 
        SELECT 387,1191, 'Building and Contents Insurance',1 UNION ALL 
        SELECT 388,1192, 'Building and Contents Insurance',1 UNION ALL 
        SELECT 389,1194, 'Building and Contents Insurance',1 UNION ALL 
        SELECT 386,1210, 'Other Investments',1 
 
        SET IDENTITY_INSERT TRefPlanTypeToSection OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '54FB591D-2BFB-4D15-9C23-C484DA88FE15', 
         'Initial load (312 total rows, file 1 of 1) for table TRefPlanTypeToSection',
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
-- #Rows Exported: 312
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
