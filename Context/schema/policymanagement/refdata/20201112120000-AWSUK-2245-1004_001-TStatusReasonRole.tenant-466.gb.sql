 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TStatusReasonRole
--    Join: join tstatusreason r on r.statusreasonid = TStatusReasonRole.StatusReasonId
--   Where: WHERE r.IndigoClientId = 466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '456C2B90-9168-4684-B126-D55CE15132F5'
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
        SET IDENTITY_INSERT TStatusReasonRole ON; 
 
        INSERT INTO TStatusReasonRole([StatusReasonRoleId], [RoleId], [StatusReasonId], [ConcurrencyId])
        SELECT 15997,4013,5727,1 UNION ALL 
        SELECT 15998,4015,5727,1 UNION ALL 
        SELECT 15999,4010,5727,1 UNION ALL 
        SELECT 16000,4013,5728,1 UNION ALL 
        SELECT 16001,4015,5728,1 UNION ALL 
        SELECT 16002,4010,5728,1 UNION ALL 
        SELECT 16003,4013,5729,1 UNION ALL 
        SELECT 16004,4014,5729,1 UNION ALL 
        SELECT 16005,4015,5729,1 UNION ALL 
        SELECT 16006,4010,5729,1 UNION ALL 
        SELECT 16007,4013,5730,1 UNION ALL 
        SELECT 16008,4015,5730,1 UNION ALL 
        SELECT 16009,4010,5730,1 UNION ALL 
        SELECT 16010,4013,5731,1 UNION ALL 
        SELECT 16011,4015,5731,1 UNION ALL 
        SELECT 16012,4010,5731,1 UNION ALL 
        SELECT 16013,4013,5732,1 UNION ALL 
        SELECT 16014,4015,5732,1 UNION ALL 
        SELECT 16015,4010,5732,1 UNION ALL 
        SELECT 16016,4014,5734,1 UNION ALL 
        SELECT 16017,4015,5734,1 UNION ALL 
        SELECT 16018,4010,5734,1 UNION ALL 
        SELECT 16019,4014,5735,1 UNION ALL 
        SELECT 16020,4015,5735,1 UNION ALL 
        SELECT 16021,4010,5735,1 UNION ALL 
        SELECT 16022,4014,5736,1 UNION ALL 
        SELECT 16023,4015,5736,1 UNION ALL 
        SELECT 16024,4010,5736,1 UNION ALL 
        SELECT 16025,4014,5737,1 UNION ALL 
        SELECT 16026,4015,5737,1 UNION ALL 
        SELECT 16027,4010,5737,1 UNION ALL 
        SELECT 16028,4014,5738,1 UNION ALL 
        SELECT 16029,4015,5738,1 UNION ALL 
        SELECT 16030,4010,5738,1 UNION ALL 
        SELECT 16031,4014,5739,1 UNION ALL 
        SELECT 16032,4015,5739,1 UNION ALL 
        SELECT 16033,4010,5739,1 UNION ALL 
        SELECT 16034,4014,5740,1 UNION ALL 
        SELECT 16035,4015,5740,1 UNION ALL 
        SELECT 16036,4010,5740,1 UNION ALL 
        SELECT 16037,4014,5741,1 UNION ALL 
        SELECT 16038,4015,5741,1 UNION ALL 
        SELECT 16039,4010,5741,1 UNION ALL 
        SELECT 16040,4013,5741,1 UNION ALL 
        SELECT 16041,4014,5742,1 
 
        SET IDENTITY_INSERT TStatusReasonRole OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '456C2B90-9168-4684-B126-D55CE15132F5', 
         'Initial load (45 total rows, file 1 of 1) for table TStatusReasonRole',
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
-- #Rows Exported: 45
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
