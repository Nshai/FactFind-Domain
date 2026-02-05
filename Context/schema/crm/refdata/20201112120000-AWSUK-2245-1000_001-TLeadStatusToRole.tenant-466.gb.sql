 
-----------------------------------------------------------------------------
-- Table: CRM.TLeadStatusToRole
--    Join: 
--   Where: WHERE TenantId=466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6E83E5BE-C9D3-4689-A099-375F5B256A5C'
     AND TenantId = 466
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TLeadStatusToRole ON; 
 
        INSERT INTO TLeadStatusToRole([LeadStatusToRoleId], [LeadStatusId], [RoleId], [TenantId], [ConcurrencyId])
        SELECT 266,1511,4010,466,1 UNION ALL 
        SELECT 267,1512,4010,466,1 UNION ALL 
        SELECT 268,1513,4010,466,1 UNION ALL 
        SELECT 269,1514,4010,466,1 UNION ALL 
        SELECT 270,1511,4011,466,1 UNION ALL 
        SELECT 271,1512,4011,466,1 UNION ALL 
        SELECT 272,1513,4011,466,1 UNION ALL 
        SELECT 273,1514,4011,466,1 UNION ALL 
        SELECT 274,1511,4012,466,1 UNION ALL 
        SELECT 275,1512,4012,466,1 UNION ALL 
        SELECT 276,1513,4012,466,1 UNION ALL 
        SELECT 277,1514,4012,466,1 UNION ALL 
        SELECT 278,1511,4013,466,1 UNION ALL 
        SELECT 279,1512,4013,466,1 UNION ALL 
        SELECT 280,1513,4013,466,1 UNION ALL 
        SELECT 281,1514,4013,466,1 UNION ALL 
        SELECT 282,1511,4014,466,1 UNION ALL 
        SELECT 283,1512,4014,466,1 UNION ALL 
        SELECT 284,1513,4014,466,1 UNION ALL 
        SELECT 285,1514,4014,466,1 UNION ALL 
        SELECT 286,1511,4015,466,1 UNION ALL 
        SELECT 287,1512,4015,466,1 UNION ALL 
        SELECT 288,1513,4015,466,1 UNION ALL 
        SELECT 289,1514,4015,466,1 UNION ALL 
        SELECT 290,1511,4016,466,1 UNION ALL 
        SELECT 291,1512,4016,466,1 UNION ALL 
        SELECT 292,1513,4016,466,1 UNION ALL 
        SELECT 293,1514,4016,466,1 UNION ALL 
        SELECT 294,1511,4017,466,1 UNION ALL 
        SELECT 295,1512,4017,466,1 UNION ALL 
        SELECT 296,1513,4017,466,1 UNION ALL 
        SELECT 297,1514,4017,466,1 UNION ALL 
        SELECT 298,1511,4018,466,1 UNION ALL 
        SELECT 299,1512,4018,466,1 UNION ALL 
        SELECT 300,1513,4018,466,1 UNION ALL 
        SELECT 301,1514,4018,466,1 UNION ALL 
        SELECT 302,1511,4019,466,1 UNION ALL 
        SELECT 303,1512,4019,466,1 UNION ALL 
        SELECT 304,1513,4019,466,1 UNION ALL 
        SELECT 305,1514,4019,466,1 
 
        SET IDENTITY_INSERT TLeadStatusToRole OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6E83E5BE-C9D3-4689-A099-375F5B256A5C', 
         'Initial load (40 total rows, file 1 of 1) for table TLeadStatusToRole',
         466, 
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
-- #Rows Exported: 40
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
